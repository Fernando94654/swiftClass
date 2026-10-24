import Foundation
import Observation
import SwiftData

// Clean Code: single responsibility - keeps the list and does create, update and delete
@MainActor
@Observable
class BookViewModel {
    var books: [Book] = []

    // The context comes from the View (@Environment), which gets it from the App
    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        self.context = context
        load()
    }

    func load() {
        guard let context else { return }
        let descriptor = FetchDescriptor<Book>(sortBy: [SortDescriptor(\.dateAdded)])
        books = (try? context.fetch(descriptor)) ?? []
    }

    func add(title: String, author: String, isRead: Bool, summary: String) throws {
        guard Book.isValidTitle(title) else {
            throw BookError.invalidTitle
        }
        let book = Book(title: Book.clean(title),
                        author: Book.clean(author),
                        isRead: isRead,
                        dateAdded: .now,
                        summary: Book.clean(summary))
        context?.insert(book)
        try save()
        load()
    }

    func update(_ book: Book, title: String, author: String, isRead: Bool, summary: String) throws {
        guard Book.isValidTitle(title) else {
            throw BookError.invalidTitle
        }
        book.title = Book.clean(title)
        book.author = Book.clean(author)
        book.isRead = isRead
        book.summary = Book.clean(summary)
        try save()
        load()
    }

    func delete(at offsets: IndexSet) throws {
        for index in offsets {
            context?.delete(books[index])
        }
        try save()
        load()
    }

    private func save() throws {
        guard let context else { throw BookError.saveFailed }
        do {
            try context.save()
        } catch {
            // Undo the unsaved changes so the list matches the database
            context.rollback()
            throw BookError.saveFailed
        }
    }
}
