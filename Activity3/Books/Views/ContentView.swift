import SwiftUI

// Clean Code: Single Responsibility - this view only lays out the list and navigation
struct ContentView: View {
    
    @State private var bookVM = BookViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(bookVM.arrBooks) { item in
                        NavigationLink {
                            BookDetailView(book: item)
                        } label: {
                            BookRowView(book: item)
                        }
                    }
                }
            }
            .navigationTitle("Books")
        }
    }
}

#Preview {
    ContentView()
}
