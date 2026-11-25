# Swift Testing

_From: Class deck "Data Persistence and Testing" · Activity9 BookShelfTests.swift_

- Add a target: File › New › Target › Unit Testing Bundle, Testing System: Swift Testing. Run with ⌘U (Product › Test). Green check = pass, red diamond = fail.
- `import Testing` and `@testable import BookShelf` (lets tests see your internal code).
- `@Test("readable name") func ...` marks a test; `#expect(condition)` must be true; `#expect(throws: BookError.invalidTitle) { try ... }` checks an error.
- Arrange – Act – Assert: set up inputs, run the code, check the result.
- Testing pyramid: many unit tests (fast, one rule), some integration tests (ViewModel + in-memory SwiftData), few UI tests (XCUITest, slow and fragile).
- Agile flow: User Story → Acceptance Criteria → Test Cases → automated (unit/integration/UI) or manual.
- Example: US-1 "As a traveler, I want to add a travel goal…" → AC-1 "cannot save without a name" → TC-001 "Save is blocked when name is empty" → unit test of `isValidName`.
- CI runs all tests on every push: GitHub Actions or Xcode Cloud.
- The AI model can't run inside tests, so you test the non-AI logic (e.g. `titles(isRead:)`).

> **Exam trap:** Test boundaries too: `""`, `"   "` (only spaces), `"A"` (one char), a 255-char string.

```swift
import Testing
import SwiftData
@testable import BookShelf

@MainActor
struct BookShelfTests {
    private func makeViewModel() throws -> BookViewModel {
        let container = try ModelContainer(for: Book.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let viewModel = BookViewModel()
        viewModel.setContext(container.mainContext)
        return viewModel
    }

    @Test("A title must not be empty or only spaces")
    func titleValidation() {
        #expect(Book.isValidTitle("Dune"))
        #expect(!Book.isValidTitle(""))
        #expect(!Book.isValidTitle("   "))
    }

    @Test("Adding saves a book and an empty title is rejected")
    func addBook() throws {
        let viewModel = try makeViewModel()                                   // Arrange
        try viewModel.add(title: "Dune", author: "", isRead: false, summary: "") // Act
        #expect(viewModel.books.count == 1)                                   // Assert
        #expect(throws: BookError.invalidTitle) {
            try viewModel.add(title: "   ", author: "", isRead: false, summary: "")
        }
    }
}
```
