# Books

SwiftUI app (iOS, Xcode 26) that lists classic books and shows a detail screen for each one. Activity 3 homework.

## Requirements covered

- Stacks: `HStack` (row), `VStack` (list and detail), `ZStack` (cover with title overlay)
- Images: cover and gallery from `Assets.xcassets`
- `List` + `ForEach` in `ContentView`
- `NavigationStack` + `NavigationLink` to `BookDetailView`
- MVVM: `Model/Book.swift`, `ViewModel/BookViewModel.swift`, `Views/`
- Data loaded from `Books/Resources/booksData.json`

## Clean Code rule

Single Responsibility Principle: every file and type has one job. The model only describes data, the view model only loads and holds it, and each view only draws one screen or row.

## Run it on a Mac (Xcode 26)

1. `git clone <repo-url>`
2. `cd` into the folder and run `open Books.xcodeproj`
3. Pick an iPhone simulator (top bar) and press Cmd+R.
4. If Xcode asks for signing: Books target > Signing & Capabilities > choose your Personal Team (not needed for the simulator).
5. If images or data look stale: Product > Clean Build Folder, then run again.
