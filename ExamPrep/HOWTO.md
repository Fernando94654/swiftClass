# How-to guide

Each section: what it is, steps, copy-paste code, common error.

## 1. Create Swift Testing files in Xcode
**A. Project has no test target** (Xcode ≥ 16)
1. File › New › Target › iOS › **Unit Testing Bundle** › Next.
2. **Testing System: Swift Testing** › Finish. Xcode creates `<App>Tests/<App>Tests.swift`.

**B. Add a new test file**
1. Right-click the `<App>Tests` folder › New File › **Swift File** (not "Unit Test Case Class").
2. In the dialog, tick **only the Tests target** under "Targets".
3. Paste:
```swift
import Testing
@testable import MyApp          // = your app's Product Name (spaces become _)

@MainActor
struct PricingTests {
    @Test("2 General = 1600")
    func generalTwo() {
        #expect(totalPrice(zone: .general, quantity: 2, parking: false) == 1600)
    }
}
```
4. Run: **⌘U** (all) or click the ◇ diamond left of `@Test` (one). Test navigator: **⌘6**.

**Test shapes**
```swift
#expect(a == b)                                  // value check
#expect(vm.arrBooks.count == 6)
#expect(throws: BookError.invalidTitle) { try vm.add(title: "") }   // must throw
#expect(throws: Never.self) { try vm.add(title: "Ok") }             // must not throw
let first = try #require(vm.arrBooks.first)      // unwrap or fail the test
@Test(arguments: [0, 1, 4]) func ok(q: Int) { #expect(totalPrice(zone: .general, quantity: q, parking: false) >= 0) }
@Test func network() async throws { let r = try await service.fetch(); #expect(!r.isEmpty) }
```
Structure of a test: **Arrange** (create data) → **Act** (call function) → **Assert** (`#expect`).

**What to test (ask yourself)**: normal case, zero, max, max+1, negative, empty string, spaces only, same result twice.

**SwiftData test (in memory)**
```swift
@Test func insertConcert() throws {
    let container = try ModelContainer(for: Concert.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    context.insert(Concert(artist: "A", venue: "V", date: .now, rating: 3, attended: false))
    #expect(try context.fetch(FetchDescriptor<Concert>()).count == 1)
}
```
**Errors**
| Error | Fix |
|---|---|
| `No such module 'MyApp'` | wrong name in `@testable import`; see target's Product Name (Build Settings) |
| `Cannot find 'totalPrice' in scope` | function is `private`, or test file is in the wrong target |
| `main actor-isolated … in a nonisolated context` | add `@MainActor` to the test struct |
| Test file not running | file not ticked for the Tests target (File inspector › Target Membership) |

## 2. @Binding explained
**Idea**: `@State` OWNS a value. `@Binding` is a **remote control** to a value owned by someone else. The child edits the parent's value; no copy.

**Steps**
1. Parent owns it: `@State private var quantity = 1`
2. Child declares it: `@Binding var quantity: Int` (no initial value)
3. Parent passes with `$`: `Child(quantity: $quantity)`
4. Child uses it as a normal value (`Text("\(quantity)")`) or with `$` for controls (`Stepper(value: $quantity, in: 0...4)`).

```swift
struct Parent: View {
    @State private var parking = false
    @State private var showSheet = false
    var body: some View {
        Button("Open") { showSheet = true }
            .sheet(isPresented: $showSheet) {          // sheet itself uses a binding
                Child(parking: $parking).presentationDetents([.medium])
            }
    }
}
struct Child: View {
    @Binding var parking: Bool
    var body: some View { Toggle("Parking", isOn: $parking) }
}
#Preview { Child(parking: .constant(false)) }        // fake binding for previews
```
**Rules**
- `$x` turns a `@State` into a Binding. `x` is the plain value.
- Child must NOT write `= value` at declaration, or pass the plain value (`Child(parking: parking)` → error).
- Binding of one item in an array: `ForEach($items) { $item in Toggle(item.name, isOn: $item.done) }`
- `@Observable` object property: use `@Bindable var vm` then `TextField("x", text: $vm.name)`.
- `@Binding` = two-way. If the child only reads, use a plain `let`.

**Errors**: `Cannot convert value of type 'Bool' to 'Binding<Bool>'` → forgot `$`. `Missing argument for parameter 'x'` → forgot to pass it (or previews: use `.constant`).

## 3. Sheets and dismissing
| Need | Code |
|---|---|
| Open with a Bool | `@State var show = false` · `.sheet(isPresented: $show) { Sheet() }` |
| Open for a specific item | `@State var selected: Book?` · `.sheet(item: $selected) { Detail(book: $0) }` (Book: Identifiable) |
| Close from inside | `@Environment(\.dismiss) private var dismiss` · `dismiss()` |
| Half height | `.presentationDetents([.medium])` on the sheet content |
| Full-screen | `.fullScreenCover(isPresented:)` |
| Hide the drag handle | `.presentationDragIndicator(.hidden)` |
Sheet needs its own `NavigationStack` to show a toolbar/title.

## 4. Add files, JSON, images, folders
- New Swift file: right-click folder › New File › Swift File (tick the **app** target). New group: right-click › New Group.
- JSON: drag into project, tick **Copy items if needed** + app target. Check: select file › File inspector › Target Membership ✔.
- Images: open `Assets.xcassets`, drag the image in; the name is the asset name. `Image("name")`. SF Symbols: `Image(systemName: "book.closed")` (browse in the SF Symbols app / ⇧⌘L library in Xcode).
- Rename a symbol everywhere: right-click › Refactor › Rename.
- Fix "Cannot find X in scope": file not in target, typo, or missing `import SwiftUI`.

## 5. Swift language quick reference
```swift
// Optionals
var n: Int? = nil
if let v = n { print(v) }                 // unwrap
guard let v = n else { return }           // unwrap or exit
let x = n ?? 0                            // default
n?.description                            // optional chaining
// Collections
arr.append(x); arr.remove(at: i); arr.count; arr.isEmpty; arr.first
arr.map { $0 * 2 }; arr.filter { $0 > 1 }; arr.sorted { $0.year < $1.year }
arr.firstIndex(where: { $0.id == id }); arr.first(where: { $0.id == id })
arr.reduce(0) { $0 + $1.copies }          // or arr.map(\.copies).reduce(0, +)
dict["key"] = 1                           // [String: Int]
// Functions & closures
func add(_ a: Int, to b: Int = 0) -> Int { a + b }   // add(1, to: 2)
let f: (Int) -> Int = { $0 + 1 }
// Type kinds
struct S { var x = 0; mutating func inc() { x += 1 } }   // value type (copied)
class C { var x = 0 }                                    // reference type (shared)
enum Zone: String, CaseIterable { case general = "General", vip = "VIP"
    var price: Int { switch self { case .general: 800; case .vip: 3000 } } }
protocol Priced { var price: Int { get } }
extension Int { var squared: Int { self * self } }
// Errors
enum E: Error { case bad }
func run() throws { throw E.bad }
do { try run() } catch E.bad { print("bad") } catch { print(error) }
let r = try? run()                         // nil on error
// Misc
let s = "Hi \(name)"; s.trimmingCharacters(in: .whitespaces); s.isEmpty; s.count
let total = a > b ? a : b                  // ternary
for i in 0..<5 { } ; for (i, x) in arr.enumerated() { }
static let max = 4                         // belongs to the type: Type.max
private var x                              // only inside this type/file
```
- `let` constant, `var` variable. Struct property change needs `var`.
- `min(max(q, 0), 4)` = clamp q to 0...4.
- `Identifiable` needs `id`. `Codable` = `Encodable & Decodable`. `Hashable` needed for `.tag` in Pickers/ForEach of enums (enums get it free).
- Computed property: `var total: Int { price * qty }`.
- `@MainActor` = runs on the UI thread.
- `Task { await ... }` / `.task { }` run async code from a View.

## 6. Formatting values
```swift
Text(date, format: .dateTime.day().month().year())       // 25 Nov 2026
Text(date, style: .date)
Text(price, format: .currency(code: "MXN"))
Text("\(rating)/5")
Text(String(format: "%.2f", value))
TextField("Year", value: $year, format: .number.grouping(.never))   // no "2,024"
```

## 7. Common View modifiers
```swift
.padding() .frame(maxWidth: .infinity, alignment: .leading)
.font(.title) .bold() .foregroundStyle(.secondary) .background(.thinMaterial)
.clipShape(.rect(cornerRadius: 12)) .shadow(radius: 4) .opacity(0.5)
.buttonStyle(.borderedProminent) .disabled(!isValid)
.navigationTitle("T") .navigationBarTitleDisplayMode(.inline)
.listStyle(.plain) .scrollContentBackground(.hidden)
.swipeActions { Button("Delete", role: .destructive) { } }
.onTapGesture { } .onAppear { } .onChange(of: x) { old, new in }
.searchable(text: $query) .confirmationDialog("Sure?", isPresented: $show) { Button("Delete", role: .destructive) { } }
Label("Add", systemImage: "plus")
Image("name").resizable().scaledToFit()
Section("Header") { }  Divider()  Spacer()  Group { }
TabView { A().tabItem { Label("A", systemImage: "star") } }
LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) { }
```
Modifier order matters: `.padding().background(.red)` ≠ `.background(.red).padding()`.

## 8. Show a conditional / filter / sort / search
```swift
if concert.attended { Image(systemName: "checkmark.circle.fill") }
.foregroundStyle(concert.attended ? .green : .secondary)
var filtered: [Book] { query.isEmpty ? books : books.filter { $0.title.localizedCaseInsensitiveContains(query) } }
@Query(filter: #Predicate<Concert> { $0.attended == false }, sort: \Concert.date) var pending: [Concert]
```

## 9. Small persistence (no SwiftData)
```swift
@AppStorage("username") private var username = ""     // saved in UserDefaults, works like @State
```
Only for simple values (String/Int/Bool/Double). Lists of objects → SwiftData.

## 10. Debugging in Xcode
- `print(x)` appears in the bottom console (⇧⌘Y).
- Weird build errors: Product › **Clean Build Folder** (⇧⌘K), then ⌘B.
- Preview broken: ⌥⌘P resume; or just run on the simulator (⌘R).
- Click the line number to add a breakpoint; the app pauses there.
- Read errors **from the first red one**; later ones are often fallout.
- Simulator reset: Device › Erase All Content (clears SwiftData data).
- "Unprintable ASCII character": retype quotes/spaces from pasted code. Search `[^\x00-\x7F]` with Regular Expression on.

## 11. Statement → code translation
| Statement says | You write |
|---|---|
| "campo nuevo X" | property in Model (+ JSON key + `CodingKeys`, or SwiftData init param) |
| "pantalla/modal para…" | `.sheet` (+ Binding or ViewModel) |
| "detalle" | `NavigationLink` to a Detail view |
| "agregar nuevo" | toolbar + button → sheet with `Form` → `append` / `context.insert` |
| "no permitir vacío / máximo N" | `isValid` + `guard throw` + `.disabled` + tests |
| "persiste al cerrar" | SwiftData `@Model` + `.modelContainer` |
| "refleje en la lista" | change the item inside the shared array/ViewModel, not a copy |
| "pruebas / casos límite" | Swift Testing: normal + 0 + max + max+1 + empty |
| "mitad de pantalla" | `.presentationDetents([.medium])` |
| "swipe para borrar" | `.onDelete` (List/ForEach) or `.swipeActions` |

## 12. Theory quick answers
- **struct vs class**: struct = value type, copied; class = reference type, shared, needed for `@Model` and `@Observable`.
- **@State vs @Binding**: owns vs borrows. **@Observable**: class whose property changes refresh views. **@Environment**: system/shared values (dismiss, modelContext).
- **MVVM**: Model = data, View = UI, ViewModel = logic/state between them; view contains no business rules.
- **Why `id` excluded from CodingKeys**: JSON has no id; `UUID()` is generated at init.
- **Codable**: converts JSON ⇄ Swift types.
- **async/await**: wait for slow work (network) without blocking the UI; call with `await`, inside `async` func or `Task`.
- **HTTP 404/500 don't throw** in URLSession; check `statusCode`.
- **SwiftData vs JSON file**: SwiftData persists across launches and supports queries; JSON in the bundle is read-only.
- **Unit test benefits**: catch regressions, document behavior, safe refactors. **Pyramid**: many unit tests, fewer integration, fewest UI tests.
- **HCAI 7 dimensions**: Safety, Efficiency, Reliability, Privacy, Accessibility, Transparency, User Agency.
- **Foundation Models**: on-device LLM; Instructions = role/rules (developer), Prompt = user request; `@Generable` = structured output; `streamResponse` = partial results; check `availability` first.
