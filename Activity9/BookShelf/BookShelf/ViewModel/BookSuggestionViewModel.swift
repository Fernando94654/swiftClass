import Foundation
import FoundationModels
import Observation

// Clean Code: single responsibility - this class only asks the model for a book summary
@MainActor
@Observable
class BookSuggestionViewModel {
    /// The summary written so far, it grows while the model streams the answer
    private(set) var suggestion = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let session = LanguageModelSession(instructions: """
        You are a helpful librarian. Answer in English and be brief.
        If you don't know the book, say so instead of inventing details.
        """)

    /// Loads the model into memory before the first request
    func prewarm() {
        session.prewarm()
    }

    func suggestSummary(title: String, author: String) async {
        suggestion = ""
        errorMessage = nil
        if let unavailableMessage = SystemLanguageModel.default.unavailableMessage {
            errorMessage = unavailableMessage
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let prompt = Prompt { "Book: \(title). Author: \(author.isEmpty ? "unknown" : author)." }
            // A low temperature keeps the summary factual
            let stream = session.streamResponse(to: prompt,
                                                generating: BookSuggestion.self,
                                                options: GenerationOptions(temperature: 0.3))
            for try await snapshot in stream {
                let partial = snapshot.content
                suggestion = [partial.summary, partial.reason].compactMap { $0 }.joined(separator: " ")
            }
        } catch {
            errorMessage = "The suggestion couldn't be generated. Please try again."
        }
    }
}
