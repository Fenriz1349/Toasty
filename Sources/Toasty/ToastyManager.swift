//
//  ToastyManager.swift
//  Toasty
//
//  Created by Julien Cotte on 23/01/2026.
//

import SwiftUI

/// Owns the current toast state.
/// New toasts replace the previous one.
@MainActor
public final class ToastyManager: ObservableObject {

    /// Currently displayed toast (nil = hidden).
    @Published public private(set) var currentToast: ToastyMessage?

    /// True when a toast is visible.
    public var hasToast: Bool { currentToast != nil }

    public init() {}

    /// Shows a toast and replaces any existing one.
    /// - Parameters:
    ///   - message: Text to display.
    ///   - type: Visual style (default: error).
    public func show(message: String, type: ToastyType = .error) {
        currentToast = ToastyMessage(message: message, type: type)
    }

    /// Hides the toast if any.
    public func dismiss() {
        currentToast = nil
    }

    /// Shows an error toast from an Error.
    /// - Parameters:
    ///   - error: The error to display (uses LocalizedError if possible).
    ///   - fallbackMessage: Used when error has no user-facing text.
    public func showError(_ error: Error, fallbackMessage: String = "Une erreur est survenue.") {
        let trimmedFallback = fallbackMessage.trimmingCharacters(in: .whitespacesAndNewlines)

        let message: String
        if let localized = error as? LocalizedError,
           let description = localized.errorDescription?.trimmingCharacters(in: .whitespacesAndNewlines),
           !description.isEmpty {
            message = description
        } else {
            message = trimmedFallback.isEmpty ? "Une erreur est survenue." : trimmedFallback
        }

        show(message: message, type: .error)
    }
}
