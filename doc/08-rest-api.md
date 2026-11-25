# Consuming REST APIs

_From: Class PDF "Consuming REST APIs in Swift" · Activity4 RickAndMorty · Activity5 Pokedex_

- A REST API exposes resources at URLs and uses HTTP methods: GET read, POST create, PUT/PATCH update, DELETE remove. Data usually travels as JSON.
- The 5 steps: 1 `URL(string:)` → `URL?` (nil if invalid). 2 `URLRequest(url:)` (default GET, 60 s timeout). 3 `try await URLSession.shared.data(for:)` → `(Data, URLResponse)`. 3b check `(response as? HTTPURLResponse)?.statusCode == 200`. 4 `JSONDecoder().decode`. 5 assign to the array → the screen updates.
- `async` = can pause; `await` = wait here without freezing the app. `throws` = can fail; `try` = I know it can fail. Always `try await` in that order.
- URLSession only throws for transport errors (no internet, timeout). A 404 or 500 arrives as a normal response, so you must check the status code.
- Three ways to fail: an Optional (`nil`), a thrown error, and a check you write (status code).
- `DecodingError` cases: `.keyNotFound`, `.typeMismatch`, `.valueNotFound`, `.dataCorrupted`.
- Many APIs wrap the list: `{ "results": [...] }` → decode `PersonResponse` and take `.results`.
- In the View: `.task { do { try await vm.load() } catch { ... } }` and `AsyncImage(url:) { img in ... } placeholder: { ProgressView() }`.
- `@MainActor` on the ViewModel replaces `DispatchQueue.main.async` for updating the UI.
- Status codes: 200 OK, 201 Created, 204 No Content, 301/304 redirect, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 429 Too Many Requests, 500 Server Error, 503 Unavailable.

> **Exam trap:** `response as? HTTPURLResponse` is a conditional downcast: `URLResponse` is the superclass and only `HTTPURLResponse` has `statusCode`.

```swift
@MainActor @Observable
class PersonViewModel {
    var arrPeople = [Person]()

    func getPeople() async throws {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return } // 1
        let urlRequest = URLRequest(url: url)                                                     // 2
        let (data, response) = try await URLSession.shared.data(for: urlRequest)                  // 3
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }                   // 3b
        arrPeople = try JSONDecoder().decode(PersonResponse.self, from: data).results             // 4 + 5
    }
}

// Pokédex: turn every failure into one readable error type
do { ... }
catch let error as APIError { throw error }
catch is DecodingError { throw APIError.decoding }
catch { throw APIError.offline }
```
