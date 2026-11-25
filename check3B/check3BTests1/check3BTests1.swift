//
//  check3BTests.swift
//  check3BTests
//
//  Created by Marco Alejandro Galindo on 24/11/26.
//

import Testing
@testable import check3B

struct check3BTests {
    
    @MainActor @Test func testTotalPrice1() async throws {
        let viewmodel = BookViewModel()
        #expect(viewmodel.totalPrice(zona: "General $800", cantidad: 2, estacionamiento: false) == 1600)
    }
    
    @MainActor @Test func testTotalPrice2() async throws {
        let viewmodel = BookViewModel()
        #expect(viewmodel.totalPrice(zona: "VIP $3,000", cantidad: 1, estacionamiento: true) == 3250)
    }
    
    @MainActor @Test func testTotalPrice3() async throws {
        let viewmodel = BookViewModel()
        #expect(viewmodel.totalPrice(zona: "General $800", cantidad: 5, estacionamiento: false) == 3200)
    }

}
