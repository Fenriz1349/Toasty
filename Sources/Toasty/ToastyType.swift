//
//  ToastyType.swift
//  Toasty
//
//  Created by Julien Cotte on 23/01/2026.
//

import SwiftUI

/// Toast style and visuals (icon/color).
public enum ToastyType: Sendable {
    case error
    // Add .success / .info later if needed.

    public var color: Color {
        switch self {
        case .error: return .red
        }
    }

    public var iconName: String {
        switch self {
        case .error: return "exclamationmark.triangle.fill"
        }
    }
}
