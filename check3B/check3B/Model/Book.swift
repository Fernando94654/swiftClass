import Foundation
import SwiftData

// Clean Code: single responsibility - this type only describes a book and its rules
@Model
class Concert {
    var zona: String
    var cantidad: Int
    var estacionamiento: Bool
    var total: Int
    
    init(zona: String, cantidad: Int, estacionamiento: Bool, total: Int) {
        self.zona = zona
        self.cantidad = cantidad
        self.estacionamiento = estacionamiento
        self.total = total
    }

    /// Removes spaces and line breaks at the start and end of a text
    static func clean(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Business rule: a book needs a title
    static func isValidTitle(_ zona: String) -> Bool {
        !clean(zona).isEmpty
    }
}
