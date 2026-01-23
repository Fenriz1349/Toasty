//
//  ToastyView.swift
//  Toasty
//
//  Created by Julien Cotte on 23/01/2026.
//

import SwiftUI

/// Default toast UI (top banner).
public struct ToastyView: View {
    public let toast: ToastyMessage
    public let onDismiss: () -> Void

    /// Creates a toast view.
    /// - Parameters:
    ///   - toast: Message to display.
    ///   - onDismiss: Called on tap/close.
    public init(toast: ToastyMessage, onDismiss: @escaping () -> Void) {
        self.toast = toast
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.type.iconName)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))

            Text(toast.message)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.white.opacity(0.85))
                    .font(.system(size: 12, weight: .semibold))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Fermer")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(toast.type.color.opacity(0.92))
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .onTapGesture { onDismiss() } // Tap anywhere to dismiss.
    }
}
