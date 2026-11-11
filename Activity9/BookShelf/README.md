# BookShelf

Activity 8: a CRUD with SwiftUI, SwiftData, Swift Testing and Foundation Models.

## What the app does

- Create: the + button opens a form to add a book (title, author, read, summary)
- Read: the list shows the books, saved on the device
- Update: tap a book to edit it
- Delete: swipe a book to the left
- Apple Intelligence: the "Suggest with Apple Intelligence" button writes a short summary of the book with Foundation Models

## Architecture (MVVM)

- Model: `Model/Book.swift` (SwiftData `@Model`), `Model/BookError.swift`, `Model/BookSuggestion.swift` (`@Generable`)
- ViewModel: `ViewModel/BookViewModel.swift` (CRUD), `ViewModel/BookSuggestionViewModel.swift` (Foundation Models)
- Views: `Views/ContentView.swift`, `Views/BookRowView.swift`, `Views/BookFormSheet.swift`

## Error handling

- `BookError` has a readable message for each error (empty title, save failed)
- Failed saves are rolled back, and the views show an alert
- If Apple Intelligence is not available or fails, the form shows a message under the summary

## Tests

`BookShelfTests/BookShelfTests.swift` has 2 tests with Swift Testing. Press Cmd+U.

## Clean Code principles used

- Descriptive names: `isValidTitle`, `suggestSummary`, `BookFormSheet`
- Short functions and components: the row, the form and the list are separate views
- DRY: one form for adding and editing, one `clean` function for the text
- Consistent formatting
- Comments only where they help, one line each
- Error handling: `BookError` and alerts

## How to run

- Xcode 26 on a Mac, iOS 26 or later
- Foundation Models needs a device or simulator with Apple Intelligence turned on. Without it the app works, and the suggestion button shows a message.

1. `git clone <repo-url>`
2. `open Activity8/BookShelf/BookShelf.xcodeproj`
3. Pick an iPhone simulator and press Cmd+R. Press Cmd+U to run the tests.
4. If Xcode asks for signing: BookShelf target > Signing & Capabilities > choose your Personal Team.
