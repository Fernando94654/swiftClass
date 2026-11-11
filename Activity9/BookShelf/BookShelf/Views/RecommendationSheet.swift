import SwiftUI

struct RecommendationSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: BookViewModel

    @State private var recommendationViewModel = RecommendationViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Next Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
        .task { await recommend() }
    }

    @ViewBuilder
    private var content: some View {
        if let message = recommendationViewModel.errorMessage {
            ContentUnavailableView {
                Label("No Recommendation", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") { Task { await recommend() } }
            }
        } else if let recommendation = recommendationViewModel.recommendation {
            VStack(alignment: .leading, spacing: 12) {
                Text(recommendation.title ?? "")
                    .font(.title2)
                    .bold()
                Text(recommendation.author ?? "")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text(recommendation.reason ?? "")
                Label("Suggested by Apple Intelligence, based on your library", systemImage: "sparkles")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        } else {
            ProgressView("Reading your library...")
        }
    }

    private func recommend() async {
        await recommendationViewModel.recommend(using: viewModel)
    }
}

#Preview {
    RecommendationSheet(viewModel: BookViewModel())
}
