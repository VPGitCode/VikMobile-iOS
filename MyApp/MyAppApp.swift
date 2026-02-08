import SwiftUI

@main
struct MyAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .saffronTheme()
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    @Environment(\.saffronColors) private var colors

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle.angled")
                }
                .tag(0)

            ProjectsScreen()
                .tabItem {
                    Label("Projects", systemImage: "briefcase.fill")
                }
                .tag(1)

            AboutScreen()
                .tabItem {
                    Label("About", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(colors.primary)
    }
}
