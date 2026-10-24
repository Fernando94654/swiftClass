import Foundation

// Clean Code: error handling - every error has a message the user can read
enum BookError: LocalizedError, Equatable {
    case invalidTitle
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .invalidTitle:
            return "The book needs a title."
        case .saveFailed:
            return "The book couldn't be saved. Please try again."
        }
    }
}
