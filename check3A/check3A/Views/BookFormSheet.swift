import SwiftUI

// Clean Code: DRY - one form for adding (book is nil) and editing (book has a value)
struct BookFormSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: BookViewModel
    var book: Concert?

    @State private var artist = ""
    @State private var place = ""
    @State private var date = Date()
    @State private var grade = 0
    @State private var visited = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Concerts") {
                    TextField("Artist", text: $artist)
                    TextField("Place", text: $place)
                    Toggle("Visited", isOn: $visited)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Stepper("Grade: \(grade)", value: $grade, in: 1...5)
                }
            }
            .navigationTitle(book == nil ? "New Book" : "Edit Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!Concert.isValidTitle(artist))
                }
            }
            .alert("Couldn't Save", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear(perform: copyBookIntoForm)
        }
    }

    /// Copies the book into the form, so Cancel really cancels
    private func copyBookIntoForm() {
        guard let book else { return }
        artist = book.artist
        place = book.place
        date = book.date
        grade = book.grade
        visited = book.visited
    }



    private func save() {
        do {
            if let book {
                try viewModel.update(book, artist: artist, place: place, date: date, grade: grade, visited: visited)
            } else {
                try viewModel.add(artist: artist, place: place, date: date, grade: grade, visited: visited)
            }
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
