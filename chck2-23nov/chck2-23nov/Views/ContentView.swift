import SwiftUI

struct ContentView: View {
    
    @State private var bookVM = BookViewModel()
    @State private var isShowingAddSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(bookVM.arrBooks) { item in
                        NavigationLink {
                            BookDetailView(book: item, bookVM: bookVM)
                        } label: {
                            BookRowView(book: item)
                        }
                    }
                }
            }
            .navigationTitle("Books")
            .toolbar {
                Button("Add Book", systemImage: "plus") {
                    isShowingAddSheet = true
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddBookSheet(bookVM: bookVM)
            }
        }
    }
}

#Preview {
    ContentView()
}
