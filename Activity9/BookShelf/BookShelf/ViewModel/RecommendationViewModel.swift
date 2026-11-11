import Foundation
import FoundationModels
import Observation

// Clean Code: single responsibility - this class only asks the model for a recommendation
@MainActor
@Observable
class RecommendationViewModel {
    private(set) var recommendation: BookRecommendation.PartiallyGenerated?
    private(set) var errorMessage: String?

    private let instructions = """
        You recommend one book to the user.
        First call the readLibrary tool to see the books the user has read and has not read.
        Recommend a book that is not in the library and fits what the user has read.
        """

    func recommend(using viewModel: BookViewModel) async {
        recommendation = nil
        errorMessage = nil

        if let unavailableMessage = SystemLanguageModel.default.unavailableMessage {
            errorMessage = unavailableMessage
            return
        }
        guard !viewModel.books.isEmpty else {
            errorMessage = "Add some books first, so I can learn your taste."
            return
        }

        do {
            let session = LanguageModelSession(tools: [LibraryTool(viewModel: viewModel)],
                                               instructions: instructions)
            let prompt = Prompt { "Recommend the next book for me." }
            // Each snapshot has the fields generated so far
            for try await snapshot in session.streamResponse(to: prompt, generating: BookRecommendation.self) {
                recommendation = snapshot.content
            }
        } catch {
            errorMessage = "The recommendation couldn't be generated. Please try again."
        }
    }
}
