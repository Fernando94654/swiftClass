import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var viewModel = BookViewModel()

    @State private var isShowingAddSheet = false
    @State private var isShowingRecommendation = false
    @State private var bookToEdit: Book?
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.books) { book in
                    Button {
                        bookToEdit = book
                    } label: {
                        BookRowView(book: book)
                    }
                    .tint(.primary)
                }
                .onDelete(perform: delete)
            }
            .overlay {
                if viewModel.books.isEmpty {
                    ContentUnavailableView("No Books Yet",
                                           systemImage: "books.vertical",
                                           description: Text("Tap + to add your first book."))
                }
            }
            .navigationTitle("BookShelf")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Recommend", systemImage: "sparkles") {
                        isShowingRecommendation = true
                    }
                    .disabled(viewModel.books.isEmpty)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        isShowingAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                BookFormSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $isShowingRecommendation) {
                RecommendationSheet(viewModel: viewModel)
            }
            .sheet(item: $bookToEdit) { book in
                BookFormSheet(viewModel: viewModel, book: book)
            }
            .alert("Couldn't Delete", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                viewModel.setContext(context)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        do {
            try viewModel.delete(at: offsets)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}
