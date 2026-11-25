# Swift language essentials

_From: Activity3 Book.swift · Activity5 APIError.swift · Activity8 TravelGoalViewModel.swift_

- `let` is a constant, `var` can change. Types: `String`, `Int`, `Double`, `Bool`, `Date`, arrays `[Book]`, dictionaries `[String: Int]`.
- `struct` is a value type: assigning or passing it makes a copy. `class` is a reference type: everyone shares the same object. SwiftUI views and models like `Book` are structs; ViewModels and SwiftData models are classes.
- Optionals: `String?` may be `nil`. Unwrap with `if let x { }`, `guard let x else { return }`, a default `x ?? ""`, optional chaining `a?.b`, or force `x!` (crashes on nil).
- A `protocol` is a blueprint of methods and properties; a struct, class or enum adopts it: `Identifiable`, `Decodable`, `View`, `App`, `Error`.
- `enum` lists fixed cases and can carry values (`case badStatus(Int)`). A `switch` must cover every case.
- Closures are inline functions: `firstIndex(where: { $0.id == book.id })`, `$0` is the first argument.
- Functions that can fail are marked `throws`; you call them with `try` inside `do { } catch { }`.
- Generics: `func load<T: Decodable>(_ filename: String) -> T` works for any decodable type.
- `static func` belongs to the type (`Book.isValidTitle("Dune")`), not to one book. A computed property (`var id: Int { ... }`) calculates its value each time.

> **Exam trap:** `var` vs `let` inside a struct: you can't change a `let` property, and you can't change any property of a struct stored in a `let`.

```swift
enum APIError: LocalizedError {
    case invalidURL
    case badStatus(Int)                       // associated value

    var errorDescription: String? {           // computed property
        switch self {
        case .invalidURL: return "The address is invalid."
        case .badStatus(let code): return "Server error \(code)."
        }
    }
}

func update(_ goal: TravelGoal, name: String) throws {
    guard TravelGoal.isValidName(name) else {  // early exit
        throw TravelGoalError.invalidName
    }
    guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
    goals[index].name = name                   // change the one inside the array
}
```
