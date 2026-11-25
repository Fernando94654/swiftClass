# MVVM and clean code

_From: Activity8 TravelGoal (class exercise) · Activity5 Pokedex · READMEs_

- Model: the data of one item plus its business rules (`TravelGoal`, `isValidName`).
- ViewModel: an `@Observable` class that keeps the list and does add/update/delete. It applies the rules and `throw`s errors.
- View: draws the data and reacts to taps. No logic. It never changes the list directly; it asks the ViewModel, and shows an alert if the ViewModel throws.
- Folders `Model/`, `ViewModel/`, `Views/` (and `Service/` for network code in Pokédex).
- Clean code rules you used: single responsibility (one job per type/file), small views (row, detail, form separated), descriptive names (`isValidTitle`, `suggestSummary`), DRY (one form for add and edit), comments only where they help.
- Same rule in two places: `.disabled(!isValid)` in the View prevents the error; `guard ... else { throw }` in the ViewModel protects the data.

> **Exam trap:** Exam question classic: "Where does the validation go?" Model (the rule), ViewModel (enforces it), View (prevents it with `.disabled`).

```swift
// ViewModel
func add(name: String, dateAdded: Date, visited: Bool) throws {
    guard TravelGoal.isValidName(name) else {
        throw TravelGoalError.invalidName
    }
    let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    travelGoals.append(TravelGoal(name: cleanName, dateAdded: dateAdded, visited: visited))
}

// View
private func save() {
    do {
        try viewModel.add(name: name, dateAdded: dateAdded, visited: visited)
        dismiss()
    } catch {
        showError = true                         // the View only shows the error
    }
}
```
