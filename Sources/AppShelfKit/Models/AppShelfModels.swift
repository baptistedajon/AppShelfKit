import Foundation

/// A lightweight value that builds an App Store URL from a numeric app identifier.
public struct AppStoreAppIdentifier: Hashable, Codable, Sendable {
    /// The numeric App Store app identifier stored as a string.
    public let id: String

    /// The App Store URL for the app identifier.
    public var appStoreURL: URL {
        URL(string: "https://apps.apple.com/app/id\(id)") ?? URL(fileURLWithPath: "/")
    }

    /// Creates an App Store app identifier.
    ///
    /// - Parameter id: The numeric App Store app identifier stored as a string.
    public init(_ id: String) {
        self.id = id
    }
}

/// A single app entry that can be displayed in an AppShelfKit shelf.
public struct AppShelfItem: Identifiable, Hashable, Codable, Sendable {
    /// A stable identifier for the app item.
    public let id: String

    /// The display name of the app.
    public let name: String

    /// A short optional tagline or secondary title for the app.
    public let subtitle: String?

    /// Optional descriptive copy for the app.
    public let description: String?

    /// An optional remote URL for the app icon artwork.
    public let iconURL: URL?

    /// The App Store URL where users can view or download the app.
    public let appStoreURL: URL

    /// An optional category label for grouping or filtering the app.
    public let category: String?

    /// An optional hex color string used to tint app presentation.
    public let tintColorHex: String?

    /// A Boolean value indicating whether this item should be presented as featured.
    public let isFeatured: Bool

    /// Creates an app shelf item.
    ///
    /// - Parameters:
    ///   - id: A stable identifier for the app item. Defaults to a generated UUID string.
    ///   - name: The display name of the app.
    ///   - subtitle: A short optional tagline or secondary title for the app.
    ///   - description: Optional descriptive copy for the app.
    ///   - iconURL: An optional remote URL for the app icon artwork.
    ///   - appStoreURL: The App Store URL where users can view or download the app.
    ///   - category: An optional category label for grouping or filtering the app.
    ///   - tintColorHex: An optional hex color string used to tint app presentation.
    ///   - isFeatured: A Boolean value indicating whether this item should be presented as featured.
    public init(
        id: String = UUID().uuidString,
        name: String,
        subtitle: String? = nil,
        description: String? = nil,
        iconURL: URL? = nil,
        appStoreURL: URL,
        category: String? = nil,
        tintColorHex: String? = nil,
        isFeatured: Bool = false
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.description = description
        self.iconURL = iconURL
        self.appStoreURL = appStoreURL
        self.category = category
        self.tintColorHex = tintColorHex
        self.isFeatured = isFeatured
    }

    /// Creates an app shelf item using a numeric App Store app identifier.
    ///
    /// - Parameters:
    ///   - id: A stable identifier for the app item. Defaults to a generated UUID string.
    ///   - name: The display name of the app.
    ///   - subtitle: A short optional tagline or secondary title for the app.
    ///   - description: Optional descriptive copy for the app.
    ///   - iconURL: An optional remote URL for the app icon artwork.
    ///   - appStoreID: The numeric App Store app identifier stored as a string.
    ///   - category: An optional category label for grouping or filtering the app.
    ///   - tintColorHex: An optional hex color string used to tint app presentation.
    ///   - isFeatured: A Boolean value indicating whether this item should be presented as featured.
    public init(
        id: String = UUID().uuidString,
        name: String,
        subtitle: String? = nil,
        description: String? = nil,
        iconURL: URL? = nil,
        appStoreID: String,
        category: String? = nil,
        tintColorHex: String? = nil,
        isFeatured: Bool = false
    ) {
        self.init(
            id: id,
            name: name,
            subtitle: subtitle,
            description: description,
            iconURL: iconURL,
            appStoreURL: AppStoreAppIdentifier(appStoreID).appStoreURL,
            category: category,
            tintColorHex: tintColorHex,
            isFeatured: isFeatured
        )
    }
}
