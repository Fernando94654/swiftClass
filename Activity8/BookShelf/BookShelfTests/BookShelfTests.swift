import Testing
import SwiftData
@testable import BookShelf

@MainActor
struct BookShelfTests {

    @Test("A title must not be empty or only spaces")
    func titleValidation() {
        #expect(Book.isValidTitle("Dune"))
        #expect(!Book.isValidTitle(""))
        #expect(!Book.isValidTitle("   "))
    }

    @Test("Adding saves a book and an empty title is rejected")
    func addBook() throws {
        // A new fake database in memory, so the test never touches real data
        let container = try ModelContainer(for: Book.self,
                                           configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let viewModel = BookViewModel()
        viewModel.setContext(container.mainContext)

        try viewModel.add(title: "Dune", author: "Frank Herbert", isRead: false, summary: "")
        #expect(viewModel.books.count == 1)

        #expect(throws: BookError.invalidTitle) {
            try viewModel.add(title: "   ", author: "", isRead: false, summary: "")
        }
        #expect(viewModel.books.count == 1)
    }
}
