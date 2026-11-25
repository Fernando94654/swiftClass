# SwiftData (persistence)

_From: Class deck "Data Persistence and Testing" · Activity7 Birthdays · Activity8/9 BookShelf_

- SwiftData is Apple's native persistence framework, the modern replacement for Core Data, integrated with SwiftUI. Without it, the array lives in memory and disappears when the app closes.
- `@Model` turns a class into a stored type. It must be a `class` (not struct), needs its own `init`, and gets an id for free.
- `.modelContainer(for: Book.self)` on the `WindowGroup` (or ContentView) creates the database and injects it into every view.
- `@Environment(\.modelContext) private var context` reads the context: the "pen" to `insert`, `delete` and `save`.
- `@Query(sort: \Friend.birthday) var friends: [Friend]` fetches in the View and updates by itself (small apps).
- In MVVM the ViewModel gets the context (`setContext`) and uses `FetchDescriptor<Book>(sortBy: [SortDescriptor(\.dateAdded)])` with `context.fetch`.
- `try context.save()`; if it fails, `context.rollback()` undoes unsaved changes.
- Previews and tests use an in-memory store: `.modelContainer(for: Book.self, inMemory: true)` / `ModelConfiguration(isStoredInMemoryOnly: true)`.
- Because a class is a reference, update edits the object directly (no `firstIndex` needed).

> **Exam trap:** Struct → `@Model class` is the first change when you add SwiftData. The Views (add/edit sheets) don't change.

```swift
@Model
class TravelGoal {
    var name: String
    var dateAdded: Date
    var visited: Bool
    init(name: String, dateAdded: Date, visited: Bool) {
        self.name = name; self.dateAdded = dateAdded; self.visited = visited
    }
}

// App
WindowGroup { ContentView() }
    .modelContainer(for: TravelGoal.self)

// ViewModel
func load() {
    guard let context else { return }
    let descriptor = FetchDescriptor<TravelGoal>(sortBy: [SortDescriptor(\.dateAdded)])
    travelGoals = (try? context.fetch(descriptor)) ?? []
}
private func save() throws {
    guard let context else { throw TravelGoalError.saveFailed }
    do { try context.save() }
    catch { context.rollback(); throw TravelGoalError.saveFailed }
}

// View
@Environment(\.modelContext) private var context
.onAppear { viewModel.setContext(context) }
```
