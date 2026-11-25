# User controls and forms

_From: Activity7 ProfileView.swift · Activity8 BookFormSheet.swift_

- Every control that changes a value takes a binding with `$`.
- `TextField("Title", text: $title)`; numbers: `TextField("Year", value: $year, format: .number)`.
- `Toggle("Read", isOn: $isRead)` for Bool.
- `Stepper("Age: \(age)", value: $age, in: 10...100)` for +1/−1 on an Int.
- `Slider(value: $zoom, in: 1...1.3, step: 0.1)` for a Double/CGFloat in a range.
- `Picker("Avatar", selection: $selected) { ForEach(...) }` with `.pickerStyle(.segmented)`.
- `ColorPicker("Color", selection: $color)`, `DatePicker("Date", selection: $date, displayedComponents: .date)`.
- `Button("Save") { save() }` runs an action; `.disabled(condition)` greys it out (error prevention, Nielsen heuristic #5).
- `Form { Section("Book") { ... } }` groups inputs in the iOS settings style.

> **Exam trap:** A `Stepper` or `Slider` range uses `...` (closed range). `10...100` includes both ends.

```swift
@State private var age = 18
@State private var zoomLevel: CGFloat = 1.0
@State private var isProfilePublic = false
@State private var selectedAvatar = "Avatar1"

Picker("Elige tu avatar", selection: $selectedAvatar) {
    ForEach(avatars, id: \.self) { avatar in Text(avatar) }
}
.pickerStyle(.segmented)

Slider(value: $zoomLevel, in: 1...1.3, step: 0.1)
Stepper("Edad: \(age)", value: $age, in: 10...100)
Toggle(isOn: $isProfilePublic) {
    Text(isProfilePublic ? "Perfil Público" : "Perfil Privado")
}
```
