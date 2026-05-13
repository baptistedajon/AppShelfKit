import Foundation

/// Errors that can occur while loading a remote app shelf configuration.
public enum AppShelfLoadingError: Error, Equatable, Sendable, LocalizedError {
    /// The remote request failed before a response was received.
    case requestFailed(String)

    /// The remote response was not an HTTP response.
    case invalidResponse

    /// The remote response returned an unsuccessful HTTP status code.
    case unacceptableStatusCode(Int)

    /// The remote response data could not be decoded as an app shelf configuration.
    case configurationDecodingFailed(AppShelfConfigurationError)

    /// A localized message describing the loading error.
    public var errorDescription: String? {
        switch self {
        case let .requestFailed(message):
            return "Could not load AppShelf configuration: \(message)"
        case .invalidResponse:
            return "The AppShelf configuration response was not a valid HTTP response."
        case let .unacceptableStatusCode(statusCode):
            return "The AppShelf configuration request failed with HTTP status code \(statusCode)."
        case let .configurationDecodingFailed(error):
            return error.localizedDescription
        }
    }
}

/// Loads app shelf configurations from remote JSON URLs.
public actor AppShelfLoader {
    private let session: URLSession
    private let decoder: JSONDecoder

    /// Creates an app shelf loader.
    ///
    /// - Parameters:
    ///   - session: The URL session used for remote requests.
    ///   - decoder: The JSON decoder used to decode remote configuration data.
    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    /// Loads and decodes an app shelf configuration from a remote JSON URL.
    ///
    /// - Parameter url: The remote URL containing app shelf configuration JSON.
    /// - Returns: A decoded app shelf configuration.
    public func load(from url: URL) async throws -> AppShelfConfiguration {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw AppShelfLoadingError.requestFailed(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppShelfLoadingError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw AppShelfLoadingError.unacceptableStatusCode(httpResponse.statusCode)
        }

        do {
            return try AppShelfConfiguration.decode(from: data, decoder: decoder)
        } catch let error as AppShelfConfigurationError {
            throw AppShelfLoadingError.configurationDecodingFailed(error)
        }
    }
}
