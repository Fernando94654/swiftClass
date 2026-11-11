import Foundation
import SwiftData

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

    static func clean(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func isValidTitle(_ title: String) -> Bool {
        !clean(title).isEmpty
    }
}
