import AppShelfKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ListExampleView()
                    .navigationTitle("List")
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }

            NavigationStack {
                CardsExampleView()
                    .navigationTitle("Cards")
            }
            .tabItem {
                Label("Cards", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                FeaturedExampleView()
                    .navigationTitle("Featured")
            }
            .tabItem {
                Label("Featured", systemImage: "star")
            }

            NavigationStack {
                RemoteExampleView()
                    .navigationTitle("Remote")
            }
            .tabItem {
                Label("Remote", systemImage: "icloud.and.arrow.down")
            }
        }
    }
}

private struct ListExampleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                ExampleSection(title: "Hardcoded Apps") {
                    AppShelfView(
                        apps: SampleData.hardcodedApps,
                        layout: .list,
                        style: .automatic
                    )
                }

                ExampleSection(title: "Local JSON") {
                    AppShelfView(
                        apps: SampleData.localConfiguration.apps,
                        layout: .list,
                        style: .prominent
                    )
                }

                ExampleSection(title: "Compact") {
                    AppShelfView(
                        apps: SampleData.hardcodedApps,
                        layout: .compact,
                        style: .compact
                    )
                }
            }
            .padding()
        }
    }
}

private struct CardsExampleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                ExampleSection(title: "Cards") {
                    AppShelfView(
                        apps: SampleData.hardcodedApps,
                        layout: .cards,
                        style: .automatic
                    )
                }

                ExampleSection(title: "Automatic") {
                    AppShelfView(
                        apps: SampleData.stylePreviewApps,
                        layout: .compact,
                        style: .automatic
                    )
                }

                ExampleSection(title: "Minimal") {
                    AppShelfView(
                        apps: SampleData.stylePreviewApps,
                        layout: .compact,
                        style: .minimal
                    )
                }

                ExampleSection(title: "Prominent") {
                    AppShelfView(
                        apps: SampleData.stylePreviewApps,
                        layout: .compact,
                        style: .prominent
                    )
                }

                ExampleSection(title: "Compact") {
                    AppShelfView(
                        apps: SampleData.stylePreviewApps,
                        layout: .compact,
                        style: .compact
                    )
                }
            }
            .padding()
        }
    }
}

private struct FeaturedExampleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                ExampleSection(title: "Featured") {
                    AppShelfView(
                        apps: SampleData.hardcodedApps,
                        layout: .featured,
                        style: .prominent
                    )
                }

                ExampleSection(title: "Featured Minimal") {
                    AppShelfView(
                        apps: SampleData.hardcodedApps,
                        layout: .featured,
                        style: .minimal
                    )
                }
            }
            .padding()
        }
    }
}

private struct RemoteExampleView: View {
    private let placeholderURL = URL(string: "https://example.com/apps.json") ?? URL(fileURLWithPath: "/")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Remote Placeholder")
                    .font(.headline)

                Text("This tab points at a placeholder URL. Replace it with your hosted apps.json file.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                AppShelfRemoteView(
                    configurationURL: placeholderURL,
                    layout: .featured,
                    style: .prominent
                )
            }
            .padding()
        }
    }
}

private struct ExampleSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            content
        }
    }
}

private enum SampleData {
    static let hardcodedApps = [
        AppShelfItem(
            id: "placeholder-notes",
            name: "Placeholder Notes",
            subtitle: "A fake notes app",
            description: "A clearly marked sample app used to demonstrate AppShelfKit layouts.",
            appStoreID: "123456789",
            category: "Productivity",
            tintColorHex: "#2F80ED",
            isFeatured: true
        ),
        AppShelfItem(
            id: "placeholder-timer",
            name: "Placeholder Timer",
            subtitle: "Focus sessions for sample data",
            description: "A sample timer app with placeholder App Store metadata.",
            appStoreID: "234567890",
            category: "Utilities",
            tintColorHex: "#34C759"
        ),
        AppShelfItem(
            id: "placeholder-recipes",
            name: "Placeholder Recipes",
            subtitle: "Recipe ideas for previews",
            description: "A fake recipe app used in the example project.",
            appStoreID: "345678901",
            category: "Food",
            tintColorHex: "#FF9500"
        ),
    ]

    static let stylePreviewApps = Array(hardcodedApps.prefix(2))

    static var localConfiguration: AppShelfConfiguration {
        do {
            return try AppShelfConfiguration.decodeResource(named: "apps")
        } catch {
            return AppShelfConfiguration(
                title: "Fallback Apps",
                subtitle: "Bundled JSON could not be loaded.",
                apps: hardcodedApps
            )
        }
    }
}

#Preview {
    ContentView()
}
