//
//  StepData.swift
//  StepIntelligence
//
//  Created by Research and Development Tec de Monterrey on 09/03/26.
//


import Foundation

enum ActivityTrend {
    case increasing
    case decreasing
    case stable
}

struct StepData {
    var stepsToday: Int
    var weeklySteps: [Int]
    var weeklyAverage: Int
    var leastActiveDay: String
    var trend: ActivityTrend
}

extension StepData {
    static var defaultValue: StepData {
        .init(
            stepsToday: 0,
            weeklySteps: [0],
            weeklyAverage: 0,
            leastActiveDay: "",
            trend: .stable
        )
    }
}
