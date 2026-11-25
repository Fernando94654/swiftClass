import Foundation
import FoundationModels
import Observation

// Clean Code: single responsibility - this class only talks to Foundation Models
@MainActor
@Observable
class BookSuggestionViewModel {
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let instructions = """
        You are a helpful librarian. Answer in English and be brief.
        If you don't know the book, say so instead of inventing details.
        """

    /// Returns a summary for the book, or nil and an errorMessage if it can't
    func suggestSummary(title: String, author: String) async -> String? {
        errorMessage = nil
        if let unavailableMessage {
            errorMessage = unavailableMessage
            return nil
        }

        isLoading = true
        defer { isLoading = false }

        do {
            // A new session for each request, so old books don't fill its memory
            let session = LanguageModelSession(instructions: instructions)
            let prompt = "Book: \(title). Author: \(author.isEmpty ? "unknown" : author)."
            let suggestion = try await session.respond(to: prompt, generating: BookSuggestion.self).content
            return "\(suggestion.summary) \(suggestion.reason)"
        } catch {
            errorMessage = "The suggestion couldn't be generated. Please try again."
            return nil
        }
    }

    /// A readable message when the model can't be used, or nil when it is ready
    private var unavailableMessage: String? {
        switch SystemLanguageModel.default.availability {
        case .available:
            return nil
        case .unavailable(.deviceNotEligible):
            return "This device doesn't support Apple Intelligence."
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Turn on Apple Intelligence in Settings to use suggestions."
        case .unavailable(.modelNotReady):
            return "The model is still getting ready. Try again later."
        case .unavailable:
            return "Suggestions are not available right now."
        }
    }
}
