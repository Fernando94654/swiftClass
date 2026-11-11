import FoundationModels

@Generable(description: "A short summary of a book and a reason to read it")
struct BookSuggestion {
    @Guide(description: "What the book is about, in one or two sentences. Under 40 words.")
    var summary: String

    @Guide(description: "One sentence about who would enjoy this book.")
    var reason: String
}
