import Foundation
import FoundationModels

// Tool calling: the model decides when to call this to read the user's own library
struct LibraryTool: Tool {
    let name = "readLibrary"
    let description = "Returns the titles of the books in the user's library, read or not read yet"

    let viewModel: BookViewModel

    @Generable
    struct Arguments {
        @Guide(description: "true for the books already read, false for the books not read yet")
        let isRead: Bool
    }

    func call(arguments: Arguments) async throws -> [String] {
        await viewModel.titles(isRead: arguments.isRead)
    }
}
