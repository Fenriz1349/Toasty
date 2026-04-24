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
    case success
    case info

    public var color: Color {
        switch self {
        case .error:   return .red
        case .success: return .green
        case .info:    return Color(.darkGray)
        }
    }

    public var iconName: String? {
        switch self {
        case .error:   return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .info:    return nil
        }
    }
}
