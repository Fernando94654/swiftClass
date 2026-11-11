import Foundation

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
