import Foundation
import Observation
import SwiftData

// Clean Code: single responsibility - keeps the list and does create, update and delete
@MainActor
@Observable
class BookViewModel {

    // The context comes from the View (@Environment), which gets it from the App
    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        self.context = context
    }

    func add(artist: String, place: String, date: Date, grade: Int, visited: Bool) throws {
        guard Concert.isValidTitle(artist) else {
            throw BookError.invalidTitle
        }
        let book = Concert(artist: Concert.clean(artist),
                        place: Concert.clean(place),
                        date: date,
                        grade: grade,
                        visited: visited,
                        )
        context?.insert(book)
        try save()
    }

    func update(_ book: Concert, artist: String, place: String, date: Date, grade: Int, visited: Bool) throws {
        guard Concert.isValidTitle(artist) else {
            throw BookError.invalidTitle
        }
        book.artist = Concert.clean(artist)
        book.visited = visited
        book.place = place
        book.date = date
        book.grade = grade
        try save()
    }

    func delete(_ concerts: [Concert]) throws {
        for concert in concerts {
            context?.delete(concert)
        }
        try save()
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
