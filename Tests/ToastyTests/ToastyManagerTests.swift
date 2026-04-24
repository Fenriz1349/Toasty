//
//  ToastyManagerTests.swift
//  Toasty
//
//  Created by Julien Cotte on 23/01/2026.
//

import XCTest
@testable import Toasty

final class ToastyManagerTests: XCTestCase {

    @MainActor
    func test_show_setsCurrentToast() {
        let manager = ToastyManager()
        manager.show(message: "Boom")

        XCTAssertEqual(manager.currentToast, ToastyMessage(message: "Boom", type: .error))
        XCTAssertTrue(manager.hasToast)
    }

    @MainActor
    func test_show_replacesPreviousToast() {
        let manager = ToastyManager()
        manager.show(message: "First")
        manager.show(message: "Second")

        XCTAssertEqual(manager.currentToast, ToastyMessage(message: "Second", type: .error))
    }

    @MainActor
    func test_dismiss_clearsToast() {
        let manager = ToastyManager()
        manager.show(message: "Hello")
        manager.dismiss()

        XCTAssertNil(manager.currentToast)
        XCTAssertFalse(manager.hasToast)
    }

    @MainActor
    func test_showError_usesLocalizedErrorDescription() {
        struct TestError: LocalizedError {
            var errorDescription: String? { "Erreur test" }
        }

        let manager = ToastyManager()
        manager.showError(TestError(), fallbackMessage: "Fallback")

        XCTAssertEqual(manager.currentToast?.message, "Erreur test")
    }

    @MainActor
    func test_showError_usesFallbackWhenNoLocalizedDescription() {
        struct TestError: Error {}

        let manager = ToastyManager()
        manager.showError(TestError(), fallbackMessage: "Fallback")

        XCTAssertEqual(manager.currentToast?.message, "Fallback")
    }
    
    @MainActor
    func test_showSuccess_setsSuccessToast() {
        let manager = ToastyManager()
        manager.showSuccess("Succès !")

        XCTAssertEqual(manager.currentToast?.message, "Succès !")
        XCTAssertEqual(manager.currentToast?.type, .success)
    }

    @MainActor
    func test_showInfo_setsInfoToast() {
        let manager = ToastyManager()
        manager.showInfo("Info.")

        XCTAssertEqual(manager.currentToast?.message, "Info.")
        XCTAssertEqual(manager.currentToast?.type, .info)
    }

    @MainActor
    func test_showError_withString_setsErrorToast() {
        let manager = ToastyManager()
        manager.showError("Erreur directe.")

        XCTAssertEqual(manager.currentToast?.message, "Erreur directe.")
        XCTAssertEqual(manager.currentToast?.type, .error)
    }
}
