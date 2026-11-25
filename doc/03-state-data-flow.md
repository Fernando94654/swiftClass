# State and data flow

_From: Activity3 ContentView.swift · Activity7 ProfileView.swift · Activity8 BookFormSheet.swift_

- `@State` is data the view owns. When it changes, the view redraws. Mark it `private`. Use it for simple values (`String`, `Bool`, `Int`) and to keep an `@Observable` ViewModel alive: `@State private var bookVM = BookViewModel()`.
- `$name` turns state into a `Binding`: a two-way connection a control can read and write (`TextField("Title", text: $title)`).
- `@Binding var value` in a child view edits a value owned by the parent.
- `@Observable` (Observation framework) on a class: views that read a property redraw when it changes. Older code uses `ObservableObject` + `@Published` + `@StateObject`; you don't need both.
- `@Bindable` lets you make `$` bindings to properties of an `@Observable` object you received (not created).
- `@Environment` reads values the system provides: `@Environment(\.dismiss)` closes a sheet, `@Environment(\.modelContext)` gives SwiftData's context.
- A plain `let book: Book` is read-only data passed in from the parent.
- `@MainActor` runs the class on the main thread, like the UI (needed when async code updates the screen).

> **Exam trap:** Without `$` you pass the value, not the binding: "Cannot convert value of type 'String' to expected argument type 'Binding<String>'".

```swift
struct ContentView: View {
    @State private var bookVM = BookViewModel()   // the view owns one ViewModel
    @State private var isShowingAddSheet = false  // simple UI state

    var body: some View {
        NavigationStack {
            List(bookVM.arrBooks) { book in Text(book.name) }
                .toolbar {
                    Button("Add Book", systemImage: "plus") {
                        isShowingAddSheet = true          // change state → redraw
                    }
                }
                .sheet(isPresented: $isShowingAddSheet) { // binding: the sheet can set it back to false
                    AddBookSheet(bookVM: bookVM)
                }
        }
    }
}
```
