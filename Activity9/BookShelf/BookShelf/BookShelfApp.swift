import SwiftUI
import SwiftData

@main
struct BookShelfApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Creates the database and shares it with every screen
        .modelContainer(for: Book.self)
    }
}
