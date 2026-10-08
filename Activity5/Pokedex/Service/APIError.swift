import Foundation

// Clean Code: one error type with readable messages for the user
enum APIError: LocalizedError {
    case invalidURL
    case offline
    case badStatus(Int)
    case decoding

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The address of the service is invalid."
        case .offline:
            return "No connection. Please try again."
        case .badStatus(let code):
            return "The server answered with an error (code \(code)). Please try again later."
        case .decoding:
            return "We couldn't read the data from the server."
        }
    }
}
