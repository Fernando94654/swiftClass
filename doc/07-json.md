# Loading data from a JSON file

_From: Activity3 BookViewModel.swift, Book.swift, booksData.json_

- The JSON file must be in the app bundle (Target Membership ticked).
- `Bundle.main.url(forResource:withExtension:)` finds the file, `Data(contentsOf:)` reads bytes, `JSONDecoder().decode(T.self, from: data)` builds Swift values.
- The model adopts `Decodable` (read only) or `Codable` (= `Decodable` + `Encodable`).
- Property names must match JSON keys, or map them in `CodingKeys` (`case url = "hdurl"`).
- `id = UUID()` isn't in the JSON, so leave `id` out of `CodingKeys`, or decoding looks for an "id" key.
- JSON → Swift: array `[ ]` → `[Book]`, object `{ }` → struct, string → `String`, number → `Int`/`Double`, true/false → `Bool`, null or missing → Optional `String?`.
- `[Book].self` passes the type itself (a metatype) so the decoder knows what to build.

> **Exam trap:** Adding a new field (like `copies`) means three changes: the JSON, the property, and `CodingKeys`.

```swift
struct Book: Identifiable, Decodable {
    var id = UUID()                 // made locally, not in the JSON
    var name: String
    var year: Int
    var imageName: [String]
    var copies: Int

    enum CodingKeys: String, CodingKey {
        case name, year, imageName, copies   // no id
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        let data = try Data(contentsOf: file)
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename):\n\(error)")
    }
}
// arrBooks = load("booksData.json")   → T is inferred as [Book]
```
