# Reference: what each activity/checkpoint is and when to use it as a template

Folders are at the repo root. "Template for" = the exam exercise where you copy from it.

## Activities (class homework)
| Folder | What it is | Key files | Use as template when the exam asks for… |
|---|---|---|---|
| `Activity3/Books` | List of books from a JSON file, row, detail with `NavigationLink`, MVVM | `Model/Book.swift`, `ViewModel/BookViewModel.swift` (generic `load`), `Views/ContentView.swift`, `BookDetailView.swift`, `booksData.json` | JSON list + detail screen, any in-memory app (**best base for the Books exam**) |
| `Activity3/Activity03_Places` | Same pattern with places (zip resources) | `Place.swift`, `PlaceViewModel.swift` | Another JSON list if the theme is not books |
| `Activity4/RickAndMorty` | First REST call: `URLSession`, `Decodable`, `AsyncImage` | `PersonViewModel.swift`, `Person.swift` (`PersonResponse` wrapper) | Simple API fetch, wrapper `{ "results": [] }` |
| `Activity5/Pokedex` | REST with Service layer, `APIError`, loading/error/retry UI, accessibility | `Service/PokemonService.swift`, `APIError.swift`, `ErrorView.swift` | API + error handling, status codes, `ProgressView`, retry button |
| `Activity7/Profile` | Controls and state: Picker, Slider, Stepper, Toggle | `ProfileView.swift` | Any form/controls question, `@State` + `$` bindings |
| `Activity7/Birthdays` | First SwiftData app: `@Model`, `@Query`, add/delete | `Friend.swift`, `ContentView.swift` | Small SwiftData list with `@Query` (no ViewModel) |
| `Activity8/BookShelf` | Full CRUD: SwiftData + MVVM + Swift Testing + Foundation Models summary | `BookViewModel.swift`, `BookFormSheet.swift` (add AND edit), `BookError.swift`, `BookShelfTests.swift` | CRUD with persistence, validation (`isValid` + `throw` + `.disabled`), unit tests, AI suggestion |
| `Activity9/BookShelf` | Activity 8 + streaming, Tool calling, prewarm, disclosure label | `BookSuggestionViewModel.swift`, `RecommendationViewModel.swift`, `LibraryTool.swift`, `RESEARCH.md` | Foundation Models theory/code: `streamResponse`, `Tool`, `@Generable`, HCAI mapping |
| `stepIntelligence` | HealthKit steps → Foundation Models insight (`@Generable WellnessInsight`) | `StepAnalyzerViewModel.swift`, `WellnessInsight.swift`, `HealthKitService.swift` | Context engineering, availability check, streaming into a struct |

## Checkpoints
| Folder | What it is | Template for |
|---|---|---|
| `chck1-23nov` | Books list from JSON + detail screen (items 1–3, 6 of the Books statement) | Start of any "list from JSON" exam |
| `chck2-23nov` | chck1 + `copies` field, +/− in detail (`increaseBook`/`decreaseBook`), `AddBookSheet` with Stepper | Books exam items 4–5: change a field and add an item, in memory |
| `check3A` | Concerts with SwiftData: `@Model Concert`, `@Query`, add sheet, tap to mark visited, swipe delete, persistence | Checkpoint 3 exercise A, any "persist + list + CRUD" |
| `check3B` | Ticket purchase: `@Binding` form sheet, `totalPrice(...)`, Swift Testing with boundary cases | Checkpoint 3 exercise B, `@Binding`, price function, unit tests |

## Quick chooser
| The exam says… | Open first |
|---|---|
| Load JSON, list, detail | `chck1-23nov` or `Activity3/Books` |
| Add field / +/− / add new item (no persistence) | `chck2-23nov`, `ExamPrep/BooksCopies` |
| Persist after closing, swipe delete, `@Query` | `check3A`, `Activity7/Birthdays` |
| CRUD + validation + tests | `Activity8/BookShelf` |
| Form in a half-height sheet, `@Binding` | `check3B`, `ExamPrep/Checkpoint3_Tickets` |
| Price/calculation function + unit tests | `check3B` tests, `Activity8/BookShelf/BookShelfTests` |
| Call a web API | `Activity5/Pokedex` (with errors), `Activity4/RickAndMorty` (simple) |
| Controls (Slider, Stepper, Picker…) | `Activity7/Profile` |
| Apple Intelligence / AI | `Activity9`, `stepIntelligence` |
| Theory (HCAI, MVVM, testing pyramid) | `doc/` lessons 06, 10, 11, 12 |
