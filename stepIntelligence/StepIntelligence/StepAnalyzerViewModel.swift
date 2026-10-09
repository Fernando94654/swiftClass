//
//  StepAnalyzer.swift
//  StepIntelligence
//
//  Created by Research and Development Tec de Monterrey on 09/03/26.
//

import Foundation
import FoundationModels
import SwiftUI

@Observable
@MainActor
class StepAnalyzerViewModel {
    private(set) var wellnessInsight: WellnessInsight.PartiallyGenerated?
    var error: Error?
    var isLoading: Bool = false
    private let session: LanguageModelSession

    init() {
        // Build the instructions for the `LanguageModelSession`
        let instructions = Instructions {
            """
            You are a personal wellness companion.
            Rules you must always follow:
            1. Never repeat numbers or statistics — the user can already see those.
            2. Focus on how the data makes the user FEEL and what it means for their day.
            3. Your suggestedAction must be specific and creative —
            not generic advice like "go for a walk" or "stay hydrated".
            4. Tailor suggestions to realistic moments: a 5-minute stretch,
            taking the stairs, a quick walk around the block.
            5. Keep your summary under 30 words.
            6. Never give medical advice or mention calories, BMI, or heart rate zones.
            7. Be warm, human, and encouraging.
            """
        }
        self.session = LanguageModelSession(instructions: instructions)
    }

    func generateRecommendation(for data: StepData) async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        let trendText: String
        switch data.trend {
        case .increasing: trendText = "above your weekly average — great work"
        case .decreasing: trendText = "below your weekly average"
        case .stable: trendText = "close to your weekly average"
        }

        let prompt = Prompt {
            """
            User's step data:
            - Steps today: \(data.stepsToday)
            - 7-day average: \(data.weeklyAverage) steps/day
            - Least active day this week: \(data.leastActiveDay)
            - Today's activity is \(trendText).
            Generate a wellness insight and a concrete suggestion
            the user can act on today.
            """
        }

        do {
            let stream = session.streamResponse(
                to: prompt,
                generating: WellnessInsight.self,
                includeSchemaInPrompt: true
            )
            // Fill the `PartiallyGenerated` value as the stream iterates
            for try await partialResponse in stream {
                wellnessInsight = partialResponse.content
            }
        } catch {
            self.error = error
        }
    }
}
