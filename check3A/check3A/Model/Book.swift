import Foundation
import SwiftData

// Clean Code: single responsibility - this type only describes a book and its rules
@Model
class Concert {
    var artist: String
    var place: String
    var date: Date
    var grade: Int
    var visited: Bool
    
    init(artist: String, place: String, date: Date, grade: Int, visited: Bool) {
        self.artist = artist
        self.place = place
        self.date = date
        self.grade = grade
        self.visited = visited
    }

    /// Removes spaces and line breaks at the start and end of a text
    static func clean(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Business rule: a book needs a title
    static func isValidTitle(_ artist: String) -> Bool {
        !clean(artist).isEmpty
    }
}
