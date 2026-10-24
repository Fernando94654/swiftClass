import Foundation
import SwiftData

// Clean Code: single responsibility - this type only describes a book and its rules
@Model
class Book {
    var title: String
    var author: String
    var isRead: Bool
    var dateAdded: Date
    var summary: String

    init(title: String, author: String, isRead: Bool, dateAdded: Date, summary: String) {
        self.title = title
        self.author = author
        self.isRead = isRead
        self.dateAdded = dateAdded
        self.summary = summary
    }

    /// Removes spaces and line breaks at the start and end of a text
    static func clean(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Business rule: a book needs a title
    static func isValidTitle(_ title: String) -> Bool {
        !clean(title).isEmpty
    }
}
