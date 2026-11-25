import SwiftUI
import SwiftData

// Clean Code: single responsibility - this view only shows the list and asks the ViewModel to change it
struct ContentView: View {
    @Query(sort: \Concert.zona) private var concerts: [Concert]
    @Environment(\.modelContext) private var context
    @State private var viewModel = BookViewModel()

    @State private var zona = ""
    @State private var cantidad = 0
    @State private var estacionamiento = false
    @State private var total = 0
    
    @State private var isShowingAddSheet = false
    @State private var boletoToEdit: Concert?
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(concerts) { book in
                    Button {
                        boletoToEdit = book
                    } label: {
                        BookRowView(book: book)
                    }
                    .tint(.primary)
                }
                .onDelete(perform: delete)
            }
            .overlay {
                if concerts.isEmpty {
                    ContentUnavailableView("No Books Yet",
                                           systemImage: "books.vertical",
                                           description: Text("Tap + to add your first book."))
                }
            }
            .navigationTitle("Concerts")
            .toolbar {
                Button("Add Book", systemImage: "plus") {
                    isShowingAddSheet = true
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                BookFormSheet(viewModel: viewModel, zona: $zona, cantidad: $cantidad, estacionamiento: $estacionamiento, total: $total)
            }
            .sheet(item: $boletoToEdit) { book in
                BookFormSheet(viewModel: viewModel, book: book, zona: $zona, cantidad: $cantidad, estacionamiento: $estacionamiento, total: $total)
            }
            .presentationDetents([.medium])
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
            try viewModel.delete(offsets.map {concerts[$0]})
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
