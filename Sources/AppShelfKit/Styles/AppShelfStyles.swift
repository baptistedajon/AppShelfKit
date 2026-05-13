import CoreGraphics

/// Visual styling options for `AppShelfView`.
public struct AppShelfStyle: Hashable, Sendable {
    /// A Boolean value indicating whether app descriptions are displayed when available.
    public let showsDescriptions: Bool

    /// A Boolean value indicating whether app category labels are displayed when available.
    public let showsCategories: Bool

    /// A Boolean value indicating whether the open action label is displayed.
    public let showsOpenButton: Bool

    /// The corner radius used by cards, featured surfaces, and icon containers.
    public let cornerRadius: CGFloat

    /// The spacing used between visual elements.
    public let spacing: CGFloat

    /// The base icon size used by the shelf.
    public let iconSize: CGFloat

    /// Creates an app shelf style.
    ///
    /// - Parameters:
    ///   - showsDescriptions: A Boolean value indicating whether app descriptions are displayed when available.
    ///   - showsCategories: A Boolean value indicating whether app category labels are displayed when available.
    ///   - showsOpenButton: A Boolean value indicating whether the open action label is displayed.
    ///   - cornerRadius: The corner radius used by cards, featured surfaces, and icon containers.
    ///   - spacing: The spacing used between visual elements.
    ///   - iconSize: The base icon size used by the shelf.
    public init(
        showsDescriptions: Bool = false,
        showsCategories: Bool = false,
        showsOpenButton: Bool = true,
        cornerRadius: CGFloat = 12,
        spacing: CGFloat = 12,
        iconSize: CGFloat = 44
    ) {
        self.showsDescriptions = showsDescriptions
        self.showsCategories = showsCategories
        self.showsOpenButton = showsOpenButton
        self.cornerRadius = cornerRadius
        self.spacing = spacing
        self.iconSize = iconSize
    }

    /// The default balanced style for most app shelves.
    public static let automatic = AppShelfStyle()

    /// A restrained style with less visual chrome and no open action label.
    public static let minimal = AppShelfStyle(
        showsDescriptions: false,
        showsCategories: false,
        showsOpenButton: false,
        cornerRadius: 10,
        spacing: 10,
        iconSize: 40
    )

    /// A richer style that shows descriptions and category labels when available.
    public static let prominent = AppShelfStyle(
        showsDescriptions: true,
        showsCategories: true,
        showsOpenButton: true,
        cornerRadius: 16,
        spacing: 14,
        iconSize: 56
    )

    /// A dense style intended for settings, about screens, and compact surfaces.
    public static let compact = AppShelfStyle(
        showsDescriptions: false,
        showsCategories: false,
        showsOpenButton: true,
        cornerRadius: 8,
        spacing: 8,
        iconSize: 32
    )
}
