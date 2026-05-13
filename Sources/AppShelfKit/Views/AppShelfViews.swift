import SwiftUI

/// A SwiftUI view for presenting app shelf items.
public struct AppShelfView: View {
    /// The app items displayed by the shelf.
    public let apps: [AppShelfItem]

    /// The visual layout used to display the app items.
    public let layout: AppShelfLayout

    /// The visual style applied to the shelf.
    public let style: AppShelfStyle

    @Environment(\.openURL) private var openURL

    /// Creates an app shelf view.
    ///
    /// - Parameters:
    ///   - apps: The app items displayed by the shelf.
    ///   - layout: The visual layout used to display the app items.
    ///   - style: The visual style applied to the shelf.
    public init(
        apps: [AppShelfItem],
        layout: AppShelfLayout = .list,
        style: AppShelfStyle = .automatic
    ) {
        self.apps = apps
        self.layout = layout
        self.style = style
    }

    /// The content and behavior of the app shelf view.
    public var body: some View {
        Group {
            switch layout {
            case .list:
                listLayout
            case .cards:
                cardsLayout
            case .compact:
                compactLayout
            case .featured:
                featuredLayout
            }
        }
    }

    private var listLayout: some View {
        VStack(spacing: 0) {
            ForEach(apps.indices, id: \.self) { index in
                AppShelfRow(app: apps[index], presentation: .list, style: style) {
                    open(apps[index])
                }

                divider(after: index, count: apps.count, leadingPadding: style.iconSize + style.spacing)
            }
        }
    }

    private var cardsLayout: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: max(180, style.iconSize * 4)), spacing: style.spacing, alignment: .top),
            ],
            alignment: .leading,
            spacing: style.spacing
        ) {
            ForEach(apps) { app in
                AppShelfCard(app: app, style: style) {
                    open(app)
                }
            }
        }
    }

    private var compactLayout: some View {
        VStack(spacing: 0) {
            ForEach(apps.indices, id: \.self) { index in
                AppShelfRow(app: apps[index], presentation: .compact, style: style) {
                    open(apps[index])
                }

                divider(after: index, count: apps.count, leadingPadding: compactIconSize + style.spacing)
            }
        }
    }

    @ViewBuilder
    private var featuredLayout: some View {
        if let featuredApp {
            VStack(spacing: style.spacing) {
                AppShelfFeaturedCard(app: featuredApp, style: style) {
                    open(featuredApp)
                }

                VStack(spacing: 0) {
                    ForEach(secondaryApps.indices, id: \.self) { index in
                        AppShelfRow(app: secondaryApps[index], presentation: .compact, style: style) {
                            open(secondaryApps[index])
                        }

                        divider(after: index, count: secondaryApps.count, leadingPadding: compactIconSize + style.spacing)
                    }
                }
            }
        }
    }

    private var featuredApp: AppShelfItem? {
        apps.first(where: \.isFeatured) ?? apps.first
    }

    private var secondaryApps: [AppShelfItem] {
        guard let featuredApp else {
            return []
        }

        return apps.filter { $0.id != featuredApp.id }
    }

    private var compactIconSize: CGFloat {
        max(28, style.iconSize * 0.74)
    }

    @ViewBuilder
    private func divider(after index: Int, count: Int, leadingPadding: CGFloat) -> some View {
        if index < count - 1 {
            Divider()
                .padding(.leading, leadingPadding)
        }
    }

    private func open(_ app: AppShelfItem) {
        openURL(app.appStoreURL)
    }
}

private struct AppShelfRow: View {
    let app: AppShelfItem
    let presentation: Presentation
    let style: AppShelfStyle
    let open: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        Button(action: open) {
            if dynamicTypeSize.isAccessibilitySize {
                accessibilityLayout
            } else {
                standardLayout
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
    }

    private var standardLayout: some View {
        HStack(alignment: .center, spacing: rowSpacing) {
            AppShelfIconView(iconURL: app.iconURL, size: iconSize, cornerRadius: iconCornerRadius)

            textContent

            Spacer(minLength: rowSpacing)

            if style.showsOpenButton {
                AppShelfActionLabel(title: actionTitle, controlSize: actionControlSize)
            }
        }
        .padding(.vertical, verticalPadding)
        .contentShape(.rect)
    }

    private var accessibilityLayout: some View {
        VStack(alignment: .leading, spacing: max(8, rowSpacing * 0.75)) {
            HStack(alignment: .top, spacing: rowSpacing) {
                AppShelfIconView(iconURL: app.iconURL, size: iconSize, cornerRadius: iconCornerRadius)

                textContent
            }

            if style.showsOpenButton {
                AppShelfActionLabel(title: actionTitle, controlSize: actionControlSize)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, max(verticalPadding, 8))
        .contentShape(.rect)
    }

    private var textContent: some View {
        VStack(alignment: .leading, spacing: textSpacing) {
            Text(app.name)
                .font(titleFont)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            if let subtitle = app.subtitle {
                Text(subtitle)
                    .font(subtitleFont)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if style.showsDescriptions, let description = app.description {
                Text(description)
                    .font(descriptionFont)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if style.showsCategories, let category = app.category {
                AppShelfCategoryLabel(category: category)
            }
        }
    }

    private var accessibilityLabel: String {
        var components = [app.name]

        if let subtitle = app.subtitle {
            components.append(subtitle)
        }

        if style.showsCategories, let category = app.category {
            components.append(category)
        }

        return "Open \(components.joined(separator: ", "))"
    }

    private var accessibilityHint: String {
        "Opens \(app.name) in the App Store."
    }

    private var iconSize: CGFloat {
        switch presentation {
        case .list:
            style.iconSize
        case .compact:
            max(28, style.iconSize * 0.74)
        }
    }

    private var iconCornerRadius: CGFloat {
        min(max(6, style.cornerRadius), iconSize * 0.34)
    }

    private var rowSpacing: CGFloat {
        switch presentation {
        case .list:
            style.spacing
        case .compact:
            max(6, style.spacing * 0.75)
        }
    }

    private var textSpacing: CGFloat {
        switch presentation {
        case .list:
            max(3, style.spacing * 0.28)
        case .compact:
            2
        }
    }

    private var verticalPadding: CGFloat {
        switch presentation {
        case .list:
            max(8, style.spacing * 0.84)
        case .compact:
            max(5, style.spacing * 0.64)
        }
    }

    private var titleFont: Font {
        switch presentation {
        case .list:
            .body
        case .compact:
            .subheadline
        }
    }

    private var subtitleFont: Font {
        switch presentation {
        case .list:
            .subheadline
        case .compact:
            .footnote
        }
    }

    private var descriptionFont: Font {
        switch presentation {
        case .list:
            .subheadline
        case .compact:
            .footnote
        }
    }

    private var actionTitle: String {
        switch presentation {
        case .list:
            "View"
        case .compact:
            "Open"
        }
    }

    private var actionControlSize: AppShelfActionLabel.ControlSize {
        switch presentation {
        case .list:
            .regular
        case .compact:
            .small
        }
    }

    enum Presentation {
        case list
        case compact
    }
}

private struct AppShelfIconView: View {
    let iconURL: URL?
    let size: CGFloat
    let cornerRadius: CGFloat

    var body: some View {
        Group {
            if let iconURL {
                AsyncImage(url: iconURL) { phase in
                    switch phase {
                    case .empty:
                        AppIconPlaceholder(cornerRadius: cornerRadius)
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        AppIconPlaceholder(cornerRadius: cornerRadius)
                    @unknown default:
                        AppIconPlaceholder(cornerRadius: cornerRadius)
                    }
                }
            } else {
                AppIconPlaceholder(cornerRadius: cornerRadius)
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        }
        .accessibilityHidden(true)
    }
}

private struct AppIconPlaceholder: View {
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.quaternary)

            Image(systemName: "app.fill")
                .font(.title3)
                .foregroundStyle(.secondary, .tertiary)
        }
    }
}

private struct AppShelfCard: View {
    let app: AppShelfItem
    let style: AppShelfStyle
    let open: () -> Void

    var body: some View {
        Button(action: open) {
            VStack(alignment: .leading, spacing: style.spacing) {
                AppShelfIconView(iconURL: app.iconURL, size: cardIconSize, cornerRadius: iconCornerRadius)

                VStack(alignment: .leading, spacing: max(4, style.spacing * 0.32)) {
                    Text(app.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    if let subtitle = app.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if style.showsDescriptions, let description = app.description {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if style.showsCategories, let category = app.category {
                        AppShelfCategoryLabel(category: category)
                    }
                }

                Spacer(minLength: 0)

                if style.showsOpenButton {
                    AppShelfActionLabel(title: "View", controlSize: .regular)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(max(12, style.spacing))
            .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
    }

    private var accessibilityLabel: String {
        var components = [app.name]

        if let subtitle = app.subtitle {
            components.append(subtitle)
        }

        if style.showsCategories, let category = app.category {
            components.append(category)
        }

        return "Open \(components.joined(separator: ", "))"
    }

    private var accessibilityHint: String {
        "Opens \(app.name) in the App Store."
    }

    private var cardIconSize: CGFloat {
        max(style.iconSize, 44)
    }

    private var iconCornerRadius: CGFloat {
        min(max(6, style.cornerRadius), cardIconSize * 0.34)
    }

}

private struct AppShelfFeaturedCard: View {
    let app: AppShelfItem
    let style: AppShelfStyle
    let open: () -> Void

    var body: some View {
        Button(action: open) {
            VStack(alignment: .leading, spacing: style.spacing) {
                HStack(alignment: .top, spacing: style.spacing) {
                    AppShelfIconView(iconURL: app.iconURL, size: featuredIconSize, cornerRadius: iconCornerRadius)

                    VStack(alignment: .leading, spacing: max(5, style.spacing * 0.36)) {
                        Text(app.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        if let subtitle = app.subtitle {
                            Text(subtitle)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        if style.showsCategories, let category = app.category {
                            AppShelfCategoryLabel(category: category)
                        }
                    }
                }

                if style.showsDescriptions, let description = app.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if style.showsOpenButton {
                    AppShelfActionLabel(title: "View", controlSize: .regular)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(max(14, style.spacing))
            .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
    }

    private var accessibilityLabel: String {
        var components = [app.name]

        if let subtitle = app.subtitle {
            components.append(subtitle)
        }

        if style.showsCategories, let category = app.category {
            components.append(category)
        }

        return "Open featured app, \(components.joined(separator: ", "))"
    }

    private var accessibilityHint: String {
        "Opens \(app.name) in the App Store."
    }

    private var featuredIconSize: CGFloat {
        max(style.iconSize * 1.16, 48)
    }

    private var iconCornerRadius: CGFloat {
        min(max(6, style.cornerRadius), featuredIconSize * 0.34)
    }
}

private struct AppShelfActionLabel: View {
    let title: String
    let controlSize: ControlSize

    var body: some View {
        Text(title)
            .font(controlSize.font)
            .fontWeight(.semibold)
            .foregroundStyle(Color.accentColor)
            .lineLimit(1)
            .minimumScaleFactor(0.82)
            .padding(.horizontal, controlSize.horizontalPadding)
            .padding(.vertical, controlSize.verticalPadding)
            .background(.quaternary, in: Capsule())
            .accessibilityHidden(true)
    }

    enum ControlSize {
        case regular
        case small

        var font: Font {
            switch self {
            case .regular:
                .callout
            case .small:
                .footnote
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .regular:
                12
            case .small:
                10
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .regular:
                5
            case .small:
                4
            }
        }
    }
}

private struct AppShelfCategoryLabel: View {
    let category: String

    var body: some View {
        Text(category)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(.quaternary, in: Capsule())
            .accessibilityHidden(true)
    }
}

#Preview("List Layout") {
    AppShelfView(
        apps: previewApps,
        layout: .list
    )
    .padding()
}

#Preview("Cards Layout") {
    AppShelfView(
        apps: previewApps,
        layout: .cards
    )
    .padding()
}

#Preview("Compact Layout") {
    AppShelfView(
        apps: previewApps,
        layout: .compact
    )
    .padding()
}

#Preview("Featured Layout") {
    AppShelfView(
        apps: previewApps,
        layout: .featured
    )
    .padding()
}

#Preview("Automatic Style") {
    AppShelfView(
        apps: previewApps,
        layout: .list,
        style: .automatic
    )
    .padding()
}

#Preview("Minimal Style") {
    AppShelfView(
        apps: previewApps,
        layout: .cards,
        style: .minimal
    )
    .padding()
}

#Preview("Prominent Style") {
    AppShelfView(
        apps: previewApps,
        layout: .featured,
        style: .prominent
    )
    .padding()
}

#Preview("Compact Style") {
    AppShelfView(
        apps: previewApps,
        layout: .compact,
        style: .compact
    )
    .padding()
}

#Preview("Dynamic Type") {
    AppShelfView(
        apps: previewApps,
        layout: .list,
        style: .prominent
    )
    .padding()
    .dynamicTypeSize(.accessibility2)
}

#Preview("Accessibility Compact") {
    AppShelfView(
        apps: previewApps,
        layout: .compact,
        style: .compact
    )
    .padding()
    .dynamicTypeSize(.accessibility3)
}

#Preview("Accessibility Cards") {
    AppShelfView(
        apps: previewApps,
        layout: .cards,
        style: .prominent
    )
    .padding()
    .dynamicTypeSize(.accessibility4)
}

#Preview("Dark Mode") {
    AppShelfView(
        apps: previewApps,
        layout: .featured,
        style: .prominent
    )
    .padding()
    .preferredColorScheme(.dark)
}

private let previewApps = [
    AppShelfItem(
        id: "journal",
        name: "Daybook",
        subtitle: "Private daily notes",
        description: "A calm place for daily writing, reflection, and keeping track of the small details that matter.",
        iconURL: previewURL("https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/16/01/c3/1601c3ab-e739-87e1-ef87-06f944b5321a/AppIcon-0-1x_U007emarketing-0-7-0-85-220.png/128x128bb.png"),
        appStoreURL: previewURL("https://apps.apple.com/app/daybook/id123456789"),
        category: "Lifestyle",
        tintColorHex: "#2F80ED",
        isFeatured: true
    ),
    AppShelfItem(
        id: "timer",
        name: "Focus Timer",
        subtitle: "Simple sessions for deep work",
        description: "A simple timer for staying focused without turning your day into a project.",
        iconURL: previewURL("https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/0e/40/41/0e4041be-a54d-110f-c444-9e096a8fa681/AppIcon-0-1x_U007emarketing-0-10-0-85-220.png/128x128bb.png"),
        appStoreURL: previewURL("https://apps.apple.com/app/focus-timer/id234567890"),
        category: "Productivity"
    ),
    AppShelfItem(
        id: "recipes",
        name: "Kitchen Notes",
        subtitle: "Recipes and grocery ideas",
        description: "Save favorite meals, quick notes, and ideas for your next grocery run.",
        iconURL: previewURL("https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/3a/3f/6e/3a3f6ea3-9015-c0ef-6a2e-8dd40d04dce0/AppIcon-0-1x_U007emarketing-0-7-0-85-220.png/128x128bb.png"),
        appStoreURL: previewURL("https://apps.apple.com/app/kitchen-notes/id345678901"),
        category: "Food"
    ),
    AppShelfItem(
        id: "long-name",
        name: "Extremely Focused Productivity Companion for Independent Creators",
        subtitle: "Plan, ship, and review your work",
        description: "A structured workspace for planning independent projects and reviewing what shipped.",
        appStoreURL: previewURL("https://apps.apple.com/app/productivity-companion/id789012345"),
        category: "Business"
    ),
    AppShelfItem(
        id: "no-subtitle",
        name: "Palette Studio",
        description: "Build and keep color palettes for visual projects.",
        appStoreURL: previewURL("https://apps.apple.com/app/palette-studio/id890123456"),
        category: "Design"
    ),
]

private func previewURL(_ string: String) -> URL {
    URL(string: string) ?? URL(fileURLWithPath: "/")
}
