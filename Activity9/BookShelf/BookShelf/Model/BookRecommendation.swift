import FoundationModels

/// What Apple Intelligence must generate when it recommends a book
@Generable(description: "A book recommendation for the user")
struct BookRecommendation {
    @Guide(description: "The title of the recommended book")
    var title: String

    @Guide(description: "The author of the recommended book")
    var author: String

    @Guide(description: "One sentence about why this book fits the user's reading taste")
    var reason: String
}
