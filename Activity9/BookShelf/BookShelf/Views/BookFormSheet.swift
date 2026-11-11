import SwiftUI

struct BookFormSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: BookViewModel
    var book: Book?

    @State private var suggestionViewModel = BookSuggestionViewModel()
    @State private var title = ""
    @State private var author = ""
    @State private var isRead = false
    @State private var summary = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Book") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    Toggle("Read", isOn: $isRead)
                }

                Section {
                    TextField("Summary", text: $summary, axis: .vertical)
                        .lineLimit(3...6)
                    suggestionButton
                } header: {
                    Text("Summary")
                } footer: {
                    if let message = suggestionViewModel.errorMessage {
                        Text(message)
                            .foregroundStyle(.red)
                    } else if !suggestionViewModel.suggestion.isEmpty {
                        Text("Written with Apple Intelligence. Check it before you save.")
                    }
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
                        .disabled(!Book.isValidTitle(title))
                }
            }
            .alert("Couldn't Save", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear(perform: copyBookIntoForm)
            .task { suggestionViewModel.prewarm() }
            .onChange(of: suggestionViewModel.suggestion) { _, newSuggestion in
                if !newSuggestion.isEmpty { summary = newSuggestion }
            }
        }
    }

    private var suggestionButton: some View {
        Button {
            Task { await suggestionViewModel.suggestSummary(title: title, author: author) }
        } label: {
            HStack {
                Label("Suggest with Apple Intelligence", systemImage: "sparkles")
                if suggestionViewModel.isLoading {
                    Spacer()
                    ProgressView()
                }
            }
        }
        .disabled(!Book.isValidTitle(title) || suggestionViewModel.isLoading)
    }

    private func copyBookIntoForm() {
        guard let book else { return }
        title = book.title
        author = book.author
        isRead = book.isRead
        summary = book.summary
    }

    private func save() {
        do {
            if let book {
                try viewModel.update(book, title: title, author: author, isRead: isRead, summary: summary)
            } else {
                try viewModel.add(title: title, author: author, isRead: isRead, summary: summary)
            }
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
    BookFormSheet(viewModel: BookViewModel())
}
