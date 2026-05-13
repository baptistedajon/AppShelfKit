import Foundation

/// Errors that can occur while loading or decoding an app shelf configuration.
public enum AppShelfConfigurationError: Error, Equatable, Sendable, LocalizedError {
    /// The requested configuration resource could not be found in the bundle.
    case resourceNotFound(name: String, fileExtension: String, bundleIdentifier: String?)

    /// The requested configuration resource was found but could not be read.
    case resourceReadFailed(name: String, fileExtension: String, message: String)

    /// The configuration data could not be decoded.
    case decodingFailed(String)

    /// A localized message describing the configuration error.
    public var errorDescription: String? {
        switch self {
        case let .resourceNotFound(name, fileExtension, bundleIdentifier):
            let bundleName = bundleIdentifier ?? "the provided bundle"
            return "Could not find \(name).\(fileExtension) in \(bundleName)."
        case let .resourceReadFailed(name, fileExtension, message):
            return "Could not read \(name).\(fileExtension): \(message)"
        case let .decodingFailed(message):
            return "Could not decode AppShelf configuration: \(message)"
        }
    }
}

/// A JSON-decodable configuration for an app shelf.
public struct AppShelfConfiguration: Codable, Sendable {
    /// An optional title to display above the app shelf.
    public let title: String?

    /// An optional subtitle to display above the app shelf.
    public let subtitle: String?

    /// The app items included in the shelf.
    public let apps: [AppShelfItem]

    /// Creates an app shelf configuration.
    ///
    /// - Parameters:
    ///   - title: An optional title to display above the app shelf.
    ///   - subtitle: An optional subtitle to display above the app shelf.
    ///   - apps: The app items included in the shelf.
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        apps: [AppShelfItem]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.apps = apps
    }

    /// Decodes an app shelf configuration from JSON data.
    ///
    /// - Parameters:
    ///   - data: The JSON data to decode.
    ///   - decoder: The JSON decoder used to decode the configuration.
    /// - Returns: A decoded app shelf configuration.
    public static func decode(
        from data: Data,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> AppShelfConfiguration {
        do {
            return try decoder.decode(AppShelfConfiguration.self, from: data)
        } catch {
            throw AppShelfConfigurationError.decodingFailed(error.localizedDescription)
        }
    }

    /// Decodes an app shelf configuration from a local bundle resource.
    ///
    /// - Parameters:
    ///   - name: The resource file name without its file extension.
    ///   - fileExtension: The resource file extension. Defaults to `json`.
    ///   - bundle: The bundle containing the resource. Defaults to `.main`.
    ///   - decoder: The JSON decoder used to decode the configuration.
    /// - Returns: A decoded app shelf configuration.
    public static func decodeResource(
        named name: String,
        withExtension fileExtension: String = "json",
        in bundle: Bundle = .main,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> AppShelfConfiguration {
        guard let resourceURL = bundle.url(forResource: name, withExtension: fileExtension) else {
            throw AppShelfConfigurationError.resourceNotFound(
                name: name,
                fileExtension: fileExtension,
                bundleIdentifier: bundle.bundleIdentifier
            )
        }

        let data: Data

        do {
            data = try Data(contentsOf: resourceURL)
        } catch {
            throw AppShelfConfigurationError.resourceReadFailed(
                name: name,
                fileExtension: fileExtension,
                message: error.localizedDescription
            )
        }

        return try decode(from: data, decoder: decoder)
    }
}

/// The visual layout used by `AppShelfView`.
public enum AppShelfLayout: String, CaseIterable, Hashable, Codable, Sendable {
    /// A vertical list with full app rows.
    case list

    /// An adaptive grid of app cards.
    case cards

    /// A compact vertical list for settings, about screens, and tighter surfaces.
    case compact

    /// A large featured app followed by smaller app rows.
    case featured
}
