import Foundation
import Testing
@testable import AppShelfKit

@Test func packageNameMatchesProductName() {
    #expect(AppShelfKit.packageName == "AppShelfKit")
}

@Test func appShelfItemInitializesWithRequiredValuesAndDefaults() throws {
    let appStoreURL = try #require(URL(string: "https://apps.apple.com/app/example/id123456789"))

    let item = AppShelfItem(
        id: "example-app",
        name: "Example App",
        appStoreURL: appStoreURL
    )

    #expect(item.id == "example-app")
    #expect(item.name == "Example App")
    #expect(item.subtitle == nil)
    #expect(item.description == nil)
    #expect(item.iconURL == nil)
    #expect(item.appStoreURL == appStoreURL)
    #expect(item.category == nil)
    #expect(item.tintColorHex == nil)
    #expect(item.isFeatured == false)
}

@Test func appShelfItemInitializesWithAllValues() throws {
    let iconURL = try #require(URL(string: "https://example.com/icon.png"))
    let appStoreURL = try #require(URL(string: "https://apps.apple.com/app/example/id123456789"))

    let item = AppShelfItem(
        id: "example-app",
        name: "Example App",
        subtitle: "Build faster",
        description: "A focused app for getting work done.",
        iconURL: iconURL,
        appStoreURL: appStoreURL,
        category: "Productivity",
        tintColorHex: "#3366FF",
        isFeatured: true
    )

    #expect(item.id == "example-app")
    #expect(item.name == "Example App")
    #expect(item.subtitle == "Build faster")
    #expect(item.description == "A focused app for getting work done.")
    #expect(item.iconURL == iconURL)
    #expect(item.appStoreURL == appStoreURL)
    #expect(item.category == "Productivity")
    #expect(item.tintColorHex == "#3366FF")
    #expect(item.isFeatured == true)
}

@Test func appStoreAppIdentifierBuildsAppStoreURL() throws {
    let identifier = AppStoreAppIdentifier("123456789")

    #expect(identifier.id == "123456789")
    #expect(identifier.appStoreURL == URL(string: "https://apps.apple.com/app/id123456789"))
}

@Test func appShelfItemInitializesWithAppStoreID() throws {
    let iconURL = try #require(URL(string: "https://example.com/icon.png"))

    let item = AppShelfItem(
        id: "example-app",
        name: "Example App",
        subtitle: "Build faster",
        description: "A focused app for getting work done.",
        iconURL: iconURL,
        appStoreID: "123456789",
        category: "Productivity",
        tintColorHex: "#3366FF",
        isFeatured: true
    )

    #expect(item.id == "example-app")
    #expect(item.name == "Example App")
    #expect(item.subtitle == "Build faster")
    #expect(item.description == "A focused app for getting work done.")
    #expect(item.iconURL == iconURL)
    #expect(item.appStoreURL == URL(string: "https://apps.apple.com/app/id123456789"))
    #expect(item.category == "Productivity")
    #expect(item.tintColorHex == "#3366FF")
    #expect(item.isFeatured == true)
}

@Test func appShelfItemCodableRoundTripPreservesValues() throws {
    let item = try makeItem()

    let encodedItem = try JSONEncoder().encode(item)
    let decodedItem = try JSONDecoder().decode(AppShelfItem.self, from: encodedItem)

    #expect(decodedItem == item)
}

@Test func appShelfItemEqualityUsesAllStoredValues() throws {
    let item = try makeItem()
    let matchingItem = try makeItem()
    let differentItem = try makeItem(id: "different-app")

    #expect(item == matchingItem)
    #expect(item != differentItem)
}

@Test func appShelfItemHashableBehaviorDeduplicatesEqualItems() throws {
    let item = try makeItem()
    let matchingItem = try makeItem()
    let differentItem = try makeItem(id: "different-app")

    let items: Set<AppShelfItem> = [item, matchingItem, differentItem]

    #expect(items.count == 2)
    #expect(items.contains(item))
    #expect(items.contains(differentItem))
}

@Test func appShelfStyleInitializesWithCustomValues() {
    let style = AppShelfStyle(
        showsDescriptions: true,
        showsCategories: true,
        showsOpenButton: false,
        cornerRadius: 18,
        spacing: 16,
        iconSize: 52
    )

    #expect(style.showsDescriptions == true)
    #expect(style.showsCategories == true)
    #expect(style.showsOpenButton == false)
    #expect(style.cornerRadius == 18)
    #expect(style.spacing == 16)
    #expect(style.iconSize == 52)
}

@Test func appShelfStylePresetsExposeExpectedBehavior() {
    #expect(AppShelfStyle.automatic.showsOpenButton == true)
    #expect(AppShelfStyle.minimal.showsOpenButton == false)
    #expect(AppShelfStyle.prominent.showsDescriptions == true)
    #expect(AppShelfStyle.prominent.showsCategories == true)
    #expect(AppShelfStyle.compact.iconSize == 32)
}

@Test func appShelfStyleHashableBehaviorDeduplicatesEqualStyles() {
    let style = AppShelfStyle.prominent
    let matchingStyle = AppShelfStyle.prominent
    let differentStyle = AppShelfStyle.minimal

    let styles: Set<AppShelfStyle> = [style, matchingStyle, differentStyle]

    #expect(styles.count == 2)
    #expect(styles.contains(style))
    #expect(styles.contains(differentStyle))
}

@Test func appShelfLayoutExposesExpectedPublicCases() {
    #expect(AppShelfLayout.allCases == [.list, .cards, .compact, .featured])
    #expect(AppShelfLayout.list.rawValue == "list")
    #expect(AppShelfLayout.cards.rawValue == "cards")
    #expect(AppShelfLayout.compact.rawValue == "compact")
    #expect(AppShelfLayout.featured.rawValue == "featured")
}

@Test func appShelfLayoutCodableRoundTripPreservesValue() throws {
    let encodedLayout = try JSONEncoder().encode(AppShelfLayout.featured)
    let decodedLayout = try JSONDecoder().decode(AppShelfLayout.self, from: encodedLayout)

    #expect(decodedLayout == .featured)
}

@Test func appShelfConfigurationDecodesValidJSONData() throws {
    let data = try #require(validConfigurationJSON.data(using: .utf8))

    let configuration = try AppShelfConfiguration.decode(from: data)

    #expect(configuration.title == "More Apps")
    #expect(configuration.subtitle == "Apps from the same developer")
    #expect(configuration.apps.count == 2)
    #expect(configuration.apps[0].id == "daybook")
    #expect(configuration.apps[0].name == "Daybook")
    #expect(configuration.apps[0].subtitle == "Private daily notes")
    #expect(configuration.apps[0].iconURL == URL(string: "https://example.com/daybook.png"))
    #expect(configuration.apps[0].appStoreURL == URL(string: "https://apps.apple.com/app/daybook/id123456789"))
    #expect(configuration.apps[0].category == "Lifestyle")
    #expect(configuration.apps[0].tintColorHex == "#2F80ED")
    #expect(configuration.apps[0].isFeatured == true)
    #expect(configuration.apps[1].id == "focus-timer")
    #expect(configuration.apps[1].isFeatured == false)
}

@Test func appShelfConfigurationReportsInvalidJSON() throws {
    let data = try #require(invalidConfigurationJSON.data(using: .utf8))

    do {
        _ = try AppShelfConfiguration.decode(from: data)
    } catch AppShelfConfigurationError.decodingFailed {
        return
    } catch {
        Issue.record("Expected decodingFailed, got \(error)")
        return
    }

    Issue.record("Expected invalid JSON to throw")
}

@Test func appShelfConfigurationReportsMissingBundleResource() {
    do {
        _ = try AppShelfConfiguration.decodeResource(
            named: "missing-appshelf-configuration",
            in: .main
        )
    } catch let error as AppShelfConfigurationError {
        #expect(error == .resourceNotFound(
            name: "missing-appshelf-configuration",
            fileExtension: "json",
            bundleIdentifier: Bundle.main.bundleIdentifier
        ))
        return
    } catch {
        Issue.record("Expected resourceNotFound, got \(error)")
        return
    }

    Issue.record("Expected missing resource to throw")
}

@Test func appShelfLoaderLoadsRemoteConfiguration() async throws {
    let data = try #require(validConfigurationJSON.data(using: .utf8))
    let url = try #require(URL(string: "https://example.com/apps-success.json"))
    let session = try makeMockSession(
        url: url,
        statusCode: 200,
        headerFields: ["Content-Type": "application/json"],
        data: data
    )
    let loader = AppShelfLoader(session: session)

    let configuration = try await loader.load(from: url)

    #expect(configuration.title == "More Apps")
    #expect(configuration.apps.count == 2)
    #expect(configuration.apps[0].id == "daybook")
}

@Test func appShelfLoaderRejectsUnsuccessfulHTTPStatusCode() async throws {
    let url = try #require(URL(string: "https://example.com/apps-404.json"))
    let session = try makeMockSession(
        url: url,
        statusCode: 404,
        headerFields: nil,
        data: Data()
    )
    let loader = AppShelfLoader(session: session)

    do {
        _ = try await loader.load(from: url)
    } catch AppShelfLoadingError.unacceptableStatusCode(404) {
        return
    } catch {
        Issue.record("Expected unacceptableStatusCode, got \(error)")
        return
    }

    Issue.record("Expected unsuccessful HTTP status code to throw")
}

@Test func appShelfLoaderReportsRemoteDecodingFailures() async throws {
    let data = try #require(invalidConfigurationJSON.data(using: .utf8))
    let url = try #require(URL(string: "https://example.com/apps-invalid.json"))
    let session = try makeMockSession(
        url: url,
        statusCode: 200,
        headerFields: ["Content-Type": "application/json"],
        data: data
    )
    let loader = AppShelfLoader(session: session)

    do {
        _ = try await loader.load(from: url)
    } catch AppShelfLoadingError.configurationDecodingFailed(.decodingFailed) {
        return
    } catch {
        Issue.record("Expected configurationDecodingFailed, got \(error)")
        return
    }

    Issue.record("Expected invalid remote JSON to throw")
}

@Test func appShelfLoaderRejectsNonHTTPResponses() async throws {
    let url = try #require(URL(string: "https://example.com/apps-non-http.json"))
    let session = makeMockSession(
        url: url,
        response: URLResponse(
            url: url,
            mimeType: "application/json",
            expectedContentLength: 0,
            textEncodingName: nil
        ),
        data: Data()
    )
    let loader = AppShelfLoader(session: session)

    do {
        _ = try await loader.load(from: url)
    } catch AppShelfLoadingError.invalidResponse {
        return
    } catch {
        Issue.record("Expected invalidResponse, got \(error)")
        return
    }

    Issue.record("Expected non-HTTP response to throw")
}

@Test func appShelfLoaderReportsRequestFailures() async throws {
    let url = try #require(URL(string: "https://example.com/apps-request-failure.json"))
    let session = makeFailingMockSession(url: url, error: URLError(.notConnectedToInternet))
    let loader = AppShelfLoader(session: session)

    do {
        _ = try await loader.load(from: url)
    } catch AppShelfLoadingError.requestFailed {
        return
    } catch {
        Issue.record("Expected requestFailed, got \(error)")
        return
    }

    Issue.record("Expected request failure to throw")
}

private func makeItem(id: String = "example-app") throws -> AppShelfItem {
    let iconURL = try #require(URL(string: "https://example.com/icon.png"))
    let appStoreURL = try #require(URL(string: "https://apps.apple.com/app/example/id123456789"))

    return AppShelfItem(
        id: id,
        name: "Example App",
        subtitle: "Build faster",
        description: "A focused app for getting work done.",
        iconURL: iconURL,
        appStoreURL: appStoreURL,
        category: "Productivity",
        tintColorHex: "#3366FF",
        isFeatured: true
    )
}

private let validConfigurationJSON = """
{
  "title": "More Apps",
  "subtitle": "Apps from the same developer",
  "apps": [
    {
      "id": "daybook",
      "name": "Daybook",
      "subtitle": "Private daily notes",
      "description": "A calm place for daily writing.",
      "iconURL": "https://example.com/daybook.png",
      "appStoreURL": "https://apps.apple.com/app/daybook/id123456789",
      "category": "Lifestyle",
      "tintColorHex": "#2F80ED",
      "isFeatured": true
    },
    {
      "id": "focus-timer",
      "name": "Focus Timer",
      "appStoreURL": "https://apps.apple.com/app/focus-timer/id234567890",
      "isFeatured": false
    }
  ]
}
"""

private let invalidConfigurationJSON = """
{
  "title": "Broken Apps",
  "apps": [
    {
      "id": "broken",
      "name": "Broken App",
      "appStoreURL": 123
    }
  ]
}
"""

private struct MockURLProtocolResponse: Sendable {
    let response: URLResponse
    let data: Data
}

private enum MockURLProtocolResult: Sendable {
    case success(MockURLProtocolResponse)
    case failure(String)
}

private final class MockURLProtocolStorage: @unchecked Sendable {
    private let lock = NSLock()
    private var results: [URL: MockURLProtocolResult] = [:]

    func setResponse(_ response: MockURLProtocolResponse, for url: URL) {
        lock.withLock {
            results[url] = .success(response)
        }
    }

    func setFailure(_ error: Error, for url: URL) {
        lock.withLock {
            results[url] = .failure(error.localizedDescription)
        }
    }

    func response(for request: URLRequest) throws -> MockURLProtocolResponse {
        guard let url = request.url else {
            throw URLError(.badURL)
        }

        let result = lock.withLock {
            results[url]
        }

        guard let result else {
            throw URLError(.badServerResponse)
        }

        switch result {
        case let .success(response):
            return response
        case let .failure(message):
            throw MockURLProtocolError.requestFailed(message)
        }
    }
}

private enum MockURLProtocolError: Error, LocalizedError {
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case let .requestFailed(message):
            message
        }
    }
}

private final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    static let storage = MockURLProtocolStorage()

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        do {
            let mockResponse = try Self.storage.response(for: request)
            client?.urlProtocol(
                self,
                didReceive: mockResponse.response,
                cacheStoragePolicy: .notAllowed
            )
            client?.urlProtocol(self, didLoad: mockResponse.data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

private func makeMockSession(
    url: URL,
    statusCode: Int,
    headerFields: [String: String]?,
    data: Data
) throws -> URLSession {
    let response = try makeHTTPResponse(
        url: url,
        statusCode: statusCode,
        headerFields: headerFields
    )
    MockURLProtocol.storage.setResponse(
        MockURLProtocolResponse(response: response, data: data),
        for: url
    )

    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
}

private func makeMockSession(
    url: URL,
    response: URLResponse,
    data: Data
) -> URLSession {
    MockURLProtocol.storage.setResponse(
        MockURLProtocolResponse(response: response, data: data),
        for: url
    )

    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
}

private func makeFailingMockSession(url: URL, error: Error) -> URLSession {
    MockURLProtocol.storage.setFailure(error, for: url)

    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
}

private func makeHTTPResponse(
    url: URL?,
    statusCode: Int,
    headerFields: [String: String]?
) throws -> HTTPURLResponse {
    guard
        let url,
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headerFields
        )
    else {
        throw URLError(.badServerResponse)
    }

    return response
}
