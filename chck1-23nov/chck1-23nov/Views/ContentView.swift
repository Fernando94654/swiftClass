import SwiftUI

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
