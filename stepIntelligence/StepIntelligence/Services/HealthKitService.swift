//
//  HealthKitService.swift
//  StepIntelligence
//
//  Created by Research and Development Tec de Monterrey on 09/03/26.
//

import Foundation
import HealthKit

@Observable
@MainActor
class HealthKitService {

    private let store = HKHealthStore()
    private let stepType = HKQuantityType(.stepCount)

    // MARK: - Authorization

    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.notAvailable
        }
        try await store.requestAuthorization(
            toShare: [],
            read: [stepType]
        )
    }

    // MARK: - Context

    func fetchStepContext() async throws -> StepData {

        let stepsToday  = try await fetchStepsToday()
        let weeklySteps = try await fetchWeeklySteps()

        let weeklyAverage = weeklySteps.isEmpty ? 0 : weeklySteps.reduce(0, +) / weeklySteps.count

        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let minIndex = weeklySteps.indices.min(by: { weeklySteps[$0] < weeklySteps[$1] }) ?? 0
        let leastActiveDay = days[minIndex % days.count]

        let trend: ActivityTrend
        if weeklyAverage == 0 {
            trend = .stable
        } else if stepsToday >= weeklyAverage {
            trend = .increasing
        } else if Double(stepsToday) < Double(weeklyAverage) * 0.8 {
            trend = .decreasing
        } else {
            trend = .stable
        }

        return StepData(
            stepsToday:     stepsToday,
            weeklySteps:    weeklySteps,
            weeklyAverage:  weeklyAverage,
            leastActiveDay: leastActiveDay,
            trend:          trend
        )
    }

    // MARK: - Private helpers

    private func fetchStepsToday() async throws -> Int {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                //if let error {
                //    continuation.resume(throwing: error)
                //    return
                //}
                let steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                continuation.resume(returning: Int(steps))
            }
            store.execute(query)
        }
    }

    private func fetchWeeklySteps() async throws -> [Int] {
        let calendar = Calendar.current
        let now = Date()
        let sevenDaysAgo = calendar.date(
            byAdding: .day,
            value: -6,
            to: calendar.startOfDay(for: now)
        )!

        let predicate = HKQuery.predicateForSamples(
            withStart: sevenDaysAgo,
            end: now,
            options: .strictStartDate
        )

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: sevenDaysAgo,
                intervalComponents: DateComponents(day: 1)
            )

            query.initialResultsHandler = { _, results, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                var steps: [Int] = []
                results?.enumerateStatistics(from: sevenDaysAgo, to: now) { stat, _ in
                    let count = stat.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    steps.append(Int(count))
                }
                if steps.isEmpty {
                    continuation.resume(returning: Array(repeating: 0, count: 7))
                } else {
                    continuation.resume(returning: steps)
                }
            }
            store.execute(query)
        }
    }

    // MARK: - Errors

    enum HealthKitError: LocalizedError {
        case notAvailable
        case dataUnavailable

        var errorDescription: String? {
            switch self {
            case .notAvailable:    return "HealthKit is not available on this device."
            case .dataUnavailable: return "Step count data could not be retrieved."
            }
        }
    }
}
