# Lists, navigation, sheets and alerts

_From: Activity3 ContentView.swift · Activity9 ContentView.swift_

- `List` shows rows; `ForEach(items) { item in ... }` repeats a view. Items must be `Identifiable`, or use `ForEach(names, id: \.self)`.
- `NavigationStack` wraps the screen; `NavigationLink { DetailView() } label: { RowView() }` pushes a new screen.
- `.navigationTitle("Books")` and `.navigationBarTitleDisplayMode(.inline)` set the title.
- `.toolbar { ToolbarItem(placement: .confirmationAction) { ... } }` adds buttons; placements: `.cancellationAction`, `.confirmationAction`, `.topBarLeading`, `.topBarTrailing`.
- Modal: `.sheet(isPresented: $flag) { ... }` or `.sheet(item: $selected) { item in ... }` (opens when the optional is not nil; needs `Identifiable`).
- Close a sheet from inside with `@Environment(\.dismiss) private var dismiss` and `dismiss()`.
- `.alert("Couldn't Save", isPresented: $showError) { Button("OK", role: .cancel) { } }`.
- `.onDelete { offsets in ... }` on a `ForEach` adds swipe-to-delete; `offsets` is an `IndexSet`.
- `TabView` shows tabs at the bottom; `ContentUnavailableView` is the empty/error state; `.task { }` runs async code when the view appears.

> **Exam trap:** `NavigationLink` only works inside a `NavigationStack`. A sheet needs its own `NavigationStack` if it wants a title or toolbar.

```swift
NavigationStack {
    List {
        ForEach(viewModel.books) { book in
            Button { bookToEdit = book } label: { BookRowView(book: book) }
        }
        .onDelete(perform: delete)              // swipe left
    }
    .navigationTitle("BookShelf")
    .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Add Book", systemImage: "plus") { isShowingAddSheet = true }
        }
    }
    .sheet(isPresented: $isShowingAddSheet) { BookFormSheet(viewModel: viewModel) }
    .sheet(item: $bookToEdit) { book in BookFormSheet(viewModel: viewModel, book: book) }
    .alert("Couldn't Delete", isPresented: $showError) {
        Button("OK", role: .cancel) { }
    }
}
```
