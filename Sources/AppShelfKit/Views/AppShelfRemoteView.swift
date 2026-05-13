import SwiftUI

private enum AppShelfRemoteLoadingState {
    case loading
    case loaded(AppShelfConfiguration)
    case failed(String)
}

/// A SwiftUI view that loads and displays a remote app shelf configuration.
public struct AppShelfRemoteView: View {
    /// The remote URL containing app shelf configuration JSON.
    public let configurationURL: URL

    /// The visual layout used to display loaded app items.
    public let layout: AppShelfLayout

    /// The visual style applied to the loaded shelf.
    public let style: AppShelfStyle

    @State private var state: AppShelfRemoteLoadingState

    private let automaticallyLoads: Bool
    private let loadConfiguration: @Sendable (URL) async throws -> AppShelfConfiguration

    /// Creates a remote app shelf view.
    ///
    /// - Parameters:
    ///   - configurationURL: The remote URL containing app shelf configuration JSON.
    ///   - layout: The visual layout used to display loaded app items.
    ///   - style: The visual style applied to the loaded shelf.
    public init(
        configurationURL: URL,
        layout: AppShelfLayout = .list,
        style: AppShelfStyle = .automatic
    ) {
        let loader = AppShelfLoader()

        self.configurationURL = configurationURL
        self.layout = layout
        self.style = style
        self._state = State(initialValue: .loading)
        self.automaticallyLoads = true
        self.loadConfiguration = { url in
            try await loader.load(from: url)
        }
    }

    fileprivate init(
        configurationURL: URL,
        layout: AppShelfLayout = .list,
        style: AppShelfStyle = .automatic,
        initialState: AppShelfRemoteLoadingState,
        automaticallyLoads: Bool = false,
        loadConfiguration: @escaping @Sendable (URL) async throws -> AppShelfConfiguration
    ) {
        self.configurationURL = configurationURL
        self.layout = layout
        self.style = style
        self._state = State(initialValue: initialState)
        self.automaticallyLoads = automaticallyLoads
        self.loadConfiguration = loadConfiguration
    }

    /// The content and behavior of the remote app shelf view.
    public var body: some View {
        Group {
            switch state {
            case .loading:
                loadingView
            case let .loaded(configuration):
                loadedView(configuration)
            case let .failed(message):
                errorView(message)
            }
        }
        .task(id: configurationURL) {
            guard automaticallyLoads else {
                return
            }

            await load()
        }
    }

    private var loadingView: some View {
        HStack(spacing: 10) {
            ProgressView()
                .controlSize(.small)
                .accessibilityHidden(true)

            Text("Loading apps...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 16)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading apps")
    }

    private func loadedView(_ configuration: AppShelfConfiguration) -> some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            if configuration.title != nil || configuration.subtitle != nil {
                VStack(alignment: .leading, spacing: 4) {
                    if let title = configuration.title {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if let subtitle = configuration.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            AppShelfView(
                apps: configuration.apps,
                layout: layout,
                style: style
            )
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title3)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            Text("Apps are unavailable")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Apps are unavailable")
        .accessibilityHint(message)
    }

    private func load() async {
        state = .loading

        do {
            let configuration = try await loadConfiguration(configurationURL)
            state = .loaded(configuration)
        } catch {
            state = .failed(Self.friendlyMessage(for: error))
        }
    }

    private static func friendlyMessage(for error: Error) -> String {
        if let localizedError = error as? LocalizedError,
           let errorDescription = localizedError.errorDescription {
            return errorDescription
        }

        return "Please try again later."
    }
}

#Preview("Remote Loading") {
    AppShelfRemoteView(
        configurationURL: remotePreviewURL("https://example.com/apps.json"),
        layout: .list,
        style: .automatic,
        initialState: .loading,
        loadConfiguration: { _ in
            try await Task.sleep(for: .seconds(60))
            return previewRemoteConfiguration
        }
    )
    .padding()
}

#Preview("Remote Success") {
    AppShelfRemoteView(
        configurationURL: remotePreviewURL("https://example.com/apps.json"),
        layout: .featured,
        style: .prominent,
        initialState: .loaded(previewRemoteConfiguration),
        loadConfiguration: { _ in previewRemoteConfiguration }
    )
    .padding()
}

#Preview("Remote Error") {
    AppShelfRemoteView(
        configurationURL: remotePreviewURL("https://example.com/apps.json"),
        layout: .cards,
        style: .automatic,
        initialState: .failed("The app shelf could not be loaded right now."),
        loadConfiguration: { _ in previewRemoteConfiguration }
    )
    .padding()
}

#Preview("Remote Accessibility") {
    AppShelfRemoteView(
        configurationURL: remotePreviewURL("https://example.com/apps.json"),
        layout: .featured,
        style: .prominent,
        initialState: .loaded(previewRemoteConfiguration),
        loadConfiguration: { _ in previewRemoteConfiguration }
    )
    .padding()
    .dynamicTypeSize(.accessibility3)
}

private let previewRemoteConfiguration = AppShelfConfiguration(
    title: "More Apps",
    subtitle: "Apps from the same developer",
    apps: [
        AppShelfItem(
            id: "remote-journal",
            name: "Daybook",
            subtitle: "Private daily notes",
            description: "A calm place for daily writing, reflection, and keeping track of the small details that matter.",
            iconURL: remotePreviewURL("https://example.com/daybook.png"),
            appStoreURL: remotePreviewURL("https://apps.apple.com/app/daybook/id123456789"),
            category: "Lifestyle",
            isFeatured: true
        ),
        AppShelfItem(
            id: "remote-timer",
            name: "Focus Timer",
            subtitle: "Simple sessions for deep work",
            description: "A simple timer for staying focused without turning your day into a project.",
            iconURL: remotePreviewURL("https://example.com/focus-timer.png"),
            appStoreURL: remotePreviewURL("https://apps.apple.com/app/focus-timer/id234567890"),
            category: "Productivity"
        ),
        AppShelfItem(
            id: "remote-palette",
            name: "Palette Studio",
            description: "Build and keep color palettes for visual projects.",
            appStoreURL: remotePreviewURL("https://apps.apple.com/app/palette-studio/id890123456"),
            category: "Design"
        ),
    ]
)

private func remotePreviewURL(_ string: String) -> URL {
    URL(string: string) ?? URL(fileURLWithPath: "/")
}
