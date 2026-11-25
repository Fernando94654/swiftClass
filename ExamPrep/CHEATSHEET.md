# Swift exam cheatsheet

## 0. New project checklist (Xcode)
- File › New › Project › iOS › App. Interface SwiftUI. **Storage: None** (avoids the generated `Item` boilerplate). Testing System: Swift Testing (adds the test target now).
- Folders: `Model`, `ViewModel`, `Views`. ⌘R run · ⌘B build · ⌘U test · ⌘. stop.
- JSON/images: drag in, tick "Copy items" and the **app target**. Images go in `Assets.xcassets`.
- Signing error: target › Signing & Capabilities › Personal Team.
- Tests: `@testable import <AppTargetName>`. If you get "main actor-isolated" errors in tests, put `@MainActor` on the test struct.

## 1. App skeleton
```swift
@main struct MyApp: App {
    var body: some Scene { WindowGroup { ContentView() } }
}
```
SwiftData app: add `.modelContainer(for: Concert.self)` after the `WindowGroup { }`.

## 2. State (who owns the data?)
| Need | Use |
|---|---|
| Value owned by this view | `@State private var x = 0` |
| Edit parent's value in a child | child: `@Binding var x: Int` · parent passes `$x` |
| ViewModel owned by this view | `@State private var vm = MyVM()` (class is `@Observable`) |
| Close a sheet | `@Environment(\.dismiss) private var dismiss` → `dismiss()` |
| SwiftData context | `@Environment(\.modelContext) private var context` |
| Preview with a binding | `Child(x: .constant(1))` |

`$x` = Binding. Controls always take `$`: `TextField("Name", text: $name)`.

## 3. Controls
```swift
TextField("Title", text: $title)
TextField("Year", value: $year, format: .number.grouping(.never))
Toggle("Parking", isOn: $parking)
Stepper("Qty: \(qty)", value: $qty, in: 0...4)
Slider(value: $zoom, in: 1...2, step: 0.1)
DatePicker("Date", selection: $date, displayedComponents: .date)
Picker("Zone", selection: $zone) { ForEach(Zone.allCases) { Text($0.rawValue).tag($0) } }
Form { ... }            // settings-style container
```
Picker with an enum: enum must be `CaseIterable, Identifiable` and each row needs `.tag(value)`.

## 4. Lists, navigation, sheets, alerts
```swift
NavigationStack {
    List { ForEach(items) { item in
        NavigationLink { Detail(item: item) } label: { Row(item: item) }
    }.onDelete { offsets in /* delete */ } }
    .navigationTitle("Title")
    .toolbar { Button("Add", systemImage: "plus") { show = true } }
    .sheet(isPresented: $show) { AddSheet() }
    .sheet(item: $selected) { item in EditSheet(item: item) }   // item: Optional + Identifiable
    .alert("Error", isPresented: $showError) { Button("OK", role: .cancel) { } }
}
```
- Half-height sheet: `.presentationDetents([.medium])` **on the sheet's content** (inside `.sheet { }`).
- Sheet toolbar: `.cancellationAction` / `.confirmationAction` inside the sheet's own `NavigationStack`.
- Disable Save: `.disabled(!isValid)`.
- Empty state: `.overlay { if items.isEmpty { ContentUnavailableView("Empty", systemImage: "tray") } }`.

## 5. MVVM template (in memory)
```swift
struct Book: Identifiable, Decodable { var id = UUID(); var name: String; var copies: Int
    enum CodingKeys: String, CodingKey { case name, copies } }   // no id

@Observable class BookViewModel {
    var arrBooks = [Book]()
    init() { arrBooks = load("booksData.json") }
    func increase(_ b: Book) {
        guard let i = arrBooks.firstIndex(where: { $0.id == b.id }) else { return }
        arrBooks[i].copies += 1                      // change the one inside the array
    }
}
```
- Detail view must read the fresh book: `bookVM.arrBooks.first(where: { $0.id == book.id }) ?? book`.
- Never use `imageName[0]` on user-created items: use `.first`.

## 6. JSON loader (copy as is)
```swift
func load<T: Decodable>(_ filename: String) -> T {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else { fatalError("missing \(filename)") }
    do { return try JSONDecoder().decode(T.self, from: try Data(contentsOf: file)) }
    catch { fatalError("\(error)") }
}
```
New JSON field = JSON + property + `CodingKeys`. Missing in some objects → make it Optional.

## 7. SwiftData (persistence)
```swift
@Model class Concert {                    // class, not struct; needs init
    var artist: String; var rating: Int
    init(artist: String, rating: Int) { self.artist = artist; self.rating = rating }
}
// App:   WindowGroup { ContentView() }.modelContainer(for: Concert.self)
// View:  @Query(sort: \Concert.date) private var concerts: [Concert]
//        @Environment(\.modelContext) private var context
context.insert(concert)                   // add
context.delete(concerts[i])               // delete (inside onDelete loop over offsets)
concert.attended.toggle()                 // update: just change the object, it autosaves
try? context.save()                       // optional explicit save
// Preview: .modelContainer(for: Concert.self, inMemory: true)
```
- Persists automatically; no extra code needed to survive relaunch.
- `@Query` only works in a View (below `.modelContainer`). In MVVM use `FetchDescriptor<T>(sortBy: [SortDescriptor(\.date)])` + `context.fetch`.
- Test with `ModelConfiguration(isStoredInMemoryOnly: true)`.

## 8. Swift Testing
```swift
import Testing
@testable import MyApp

struct PricingTests {
    @Test("2 General, no parking = 1600")
    func two() { #expect(totalPrice(zone: .general, quantity: 2, parking: false) == 1600) }
    @Test func throwsOnEmpty() { #expect(throws: MyError.empty) { try vm.add(title: "") } }
}
```
Add a target: File › New › Target › Unit Testing Bundle, Testing System: Swift Testing. Run with ⌘U (Product › Test). Green check = pass, red diamond = fail.
Test: normal case, **boundaries** (0, max, max+1, empty, spaces only). Pure functions are easiest: keep logic out of Views.
Test names/expected values go straight from the exam statement.

## 9. Validation pattern (same rule in 3 places)
```swift
static func isValid(_ s: String) -> Bool { !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } // Model
guard Model.isValid(x) else { throw MyError.invalid }                                                    // ViewModel
.disabled(!Model.isValid(x))                                                                             // View
```

## 10. REST API (5 steps)
```swift
guard let url = URL(string: "https://...") else { return }                 // 1 URL?
let request = URLRequest(url: url)                                         // 2
let (data, response) = try await URLSession.shared.data(for: request)      // 3
guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }    // 3b 404/500 don't throw!
items = try JSONDecoder().decode([Item].self, from: data)                  // 4 + 5
// View: .task { do { try await vm.load() } catch { print(error) } }   AsyncImage(url:) { $0.resizable() } placeholder: { ProgressView() }
```
Wrapper `{ "results": [...] }` → decode a `Response` struct and take `.results`. ViewModel: `@MainActor @Observable`.

## 11. Foundation Models
```swift
@Generable struct Insight { @Guide(description: "under 30 words") var summary: String }
let session = LanguageModelSession(instructions: "rules here")            // who the model is
for try await p in session.streamResponse(to: Prompt { "data" }, generating: Insight.self) { insight = p.content } // fields Optional → if let
SystemLanguageModel.default.availability                                   // check first
```
Tool: `struct T: Tool { name, description, @Generable struct Arguments, func call(arguments:) async throws -> ... }` → `LanguageModelSession(tools: [T()], instructions:)`.

## 12. Common errors
| Error | Fix |
|---|---|
| `Cannot convert String to Binding<String>` | add `$` |
| Row tap does nothing | missing `NavigationStack` |
| `Couldn't find x.json in main bundle` | Target Membership |
| `keyNotFound` | JSON key ≠ property name / missing key → Optional |
| List not updating after change | changed a struct copy; change `arr[index]` |
| `@Model` error | must be `class` with `init` |
| Sheet not half-height | `.presentationDetents` must be inside the sheet content |
| Crash `Index out of range` | `array[0]` on empty array → `.first` |
