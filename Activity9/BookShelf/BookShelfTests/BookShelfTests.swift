import Testing
import SwiftData
@testable import BookShelf

@MainActor
struct BookShelfTests {

    /// A view model with a new fake database in memory, so a test never touches real data
    private func makeViewModel() throws -> BookViewModel {
        let container = try ModelContainer(for: Book.self,
                                           configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let viewModel = BookViewModel()
        viewModel.setContext(container.mainContext)
        return viewModel
    }

    @Test("A title must not be empty or only spaces")
    func titleValidation() {
        #expect(Book.isValidTitle("Dune"))
        #expect(!Book.isValidTitle(""))
        #expect(!Book.isValidTitle("   "))
    }

    @Test("Adding saves a book and an empty title is rejected")
    func addBook() throws {
        let viewModel = try makeViewModel()

        try viewModel.add(title: "Dune", author: "Frank Herbert", isRead: false, summary: "")
        #expect(viewModel.books.count == 1)

        #expect(throws: BookError.invalidTitle) {
            try viewModel.add(title: "   ", author: "", isRead: false, summary: "")
        }
        #expect(viewModel.books.count == 1)
    }

    @Test("The library tool gets only the titles with the asked reading status")
    func titlesByReadingStatus() throws {
        let viewModel = try makeViewModel()
        try viewModel.add(title: "Dune", author: "", isRead: true, summary: "")
        try viewModel.add(title: "Emma", author: "", isRead: false, summary: "")

        #expect(viewModel.titles(isRead: true) == ["Dune"])
        #expect(viewModel.titles(isRead: false) == ["Emma"])
    }
}
