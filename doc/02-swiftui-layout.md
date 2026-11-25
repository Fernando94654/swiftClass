# SwiftUI fundamentals and layout

_From: Class PDF "Apple Developer Introduction" · Activity3 BooksApp.swift, BookDetailView.swift_

- SwiftUI is Apple's declarative UI framework (2019): you describe what the screen looks like for the current state and SwiftUI redraws it. One codebase for iOS, iPadOS, macOS, tvOS and watchOS.
- It mixes with UIKit: put SwiftUI inside UIKit with `UIHostingController`. Widgets can only be built with SwiftUI.
- Structure: App › Scene › View. `@main` marks the entry point; `WindowGroup` is the scene; `ContentView()` is the first view.
- A view is a `struct` that conforms to `View` and has `var body: some View`. `some View` means "one specific view type that the compiler knows".
- Stacks: `VStack` (top to bottom), `HStack` (left to right), `ZStack` (back to front, layers). They take `alignment:` and `spacing:`. `Spacer()` pushes, `Divider()` draws a line.
- `LazyVStack` / `LazyHStack` only create views when they appear on screen (good for long lists inside a `ScrollView`).
- Shapes: `Rectangle()`, `Circle()`, `RoundedRectangle(cornerRadius: 30)`.
- `Image("Frankenstein")` uses Assets; `Image(systemName: "plus")` uses SF Symbols. Add `.resizable()` before `.scaledToFit()` or `.frame()`.
- Modifiers return a new view, so order matters: `.padding().background(.red)` colors the padding; `.background(.red).padding()` doesn't.
- `#Preview { ContentView() }` shows the view in the canvas.

> **Exam trap:** "Views to explore" list from class: Text, Label, Button, HStack/VStack/ZStack, LazyHStack/LazyVStack, Spacer, List, ForEach, NavigationStack, TabView, TextField, Toggle.

```swift
@main
struct BooksApp: App {                 // App protocol
    var body: some Scene {
        WindowGroup {                  // Scene
            ContentView()              // View
        }
    }
}

ZStack(alignment: .bottom) {           // layers: image behind, title in front
    Image(book.imageName[0])
        .resizable()
        .scaledToFit()
    Text(book.title)
        .font(.headline)
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(.black.opacity(0.6))
}
```
