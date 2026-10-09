import SwiftUI

struct ContentView: View {

    @State private var vm = StepAnalyzerViewModel()
    @State private var healthKitVM = StepsViewModel()

    // MARK: - Color palette
    private let backgroundTop = Color(red: 0.05, green: 0.10, blue: 0.18)
    private let backgroundBottom = Color(red: 0.04, green: 0.16, blue: 0.20)
    private let accentTeal = Color(red: 0.18, green: 0.82, blue: 0.72)
    private let accentGreen = Color(red: 0.25, green: 0.90, blue: 0.55)
    private let cardBackground = Color.white.opacity(0.07)

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Gradient background
                LinearGradient(
                    colors: [backgroundTop, backgroundBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Decorative background circles
                Circle()
                    .fill(accentTeal.opacity(0.08))
                    .frame(width: 380, height: 380)
                    .blur(radius: 60)
                    .offset(x: 120, y: -200)

                Circle()
                    .fill(accentGreen.opacity(0.06))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: -100, y: 300)

                // MARK: Main content
                ScrollView {
                    VStack(spacing: 20) {

                        // MARK: Decorative metrics header
                        HStack(spacing: 16) {
                            MetricBadge(icon: "figure.walk", label: "Pasos", color: accentTeal)
                            MetricBadge(icon: "heart.fill", label: "Salud", color: accentGreen)
                            MetricBadge(icon: "brain.head.profile", label: "IA", color: .purple.opacity(0.9))
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // MARK: Insight card
                        if let insight = vm.wellnessInsight {
                            VStack(alignment: .leading, spacing: 18) {
                                // Section: summary
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Resumen", systemImage: "doc.text.magnifyingglass")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(accentTeal)

                                    if let summary = insight.summary {
                                        Text(summary)
                                            .font(.body)
                                            .foregroundStyle(.white.opacity(0.88))
                                            .lineSpacing(4)
                                    }
                                }

                                Divider()
                                    .background(Color.white.opacity(0.12))

                                // Section: suggested action
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Acción Recomendada", systemImage: "bolt.heart.fill")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(accentGreen)

                                    if let suggestedAction = insight.suggestedAction {
                                        Text(suggestedAction)
                                            .font(.callout.weight(.medium))
                                            .foregroundStyle(.white.opacity(0.95))
                                            .lineSpacing(4)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
                            )
                            .shadow(color: accentTeal.opacity(0.15), radius: 20, x: 0, y: 8)
                            .padding(.horizontal)
                        } else {
                            // MARK: Empty state
                            VStack(spacing: 16) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 48))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [accentTeal, accentGreen],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )

                                Text("Genera tu análisis de bienestar")
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.85))

                                Text("Presiona \"Generar\" para obtener recomendaciones personalizadas basadas en tus pasos.")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.50))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                        }

                        Spacer(minLength: 40)
                    }
                }
            }
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle("Intellistep")
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "figure.walk.motion")
                            .foregroundStyle(accentTeal)
                        Text("Intellistep")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Generate", systemImage: "sparkles") {
                        Task {
                            await vm.generateRecommendation(for: healthKitVM.stepData ?? .defaultValue)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(accentGreen.opacity(0.85))
                    .disabled(vm.isLoading)
                }
            }
            .task {
                await healthKitVM.requestAccessAndLoad()
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Helper component: MetricBadge
struct MetricBadge: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(color)
                .frame(width: 48, height: 48)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Text(label)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.white.opacity(0.60))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
