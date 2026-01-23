//
//  ToastyMessage.swift
//  Toasty
//
//  Created by Julien Cotte on 23/01/2026.
//

import Foundation

/// A single toast payload (text + style).
public struct ToastyMessage: Equatable, Sendable {
    public let message: String
    public let type: ToastyType

    /// Creates a message.
    /// - Parameters:
    ///   - message: Text to display.
    ///   - type: Visual style (error, etc.).
    public init(message: String, type: ToastyType) {
        self.message = message
        self.type = type
    }
}
