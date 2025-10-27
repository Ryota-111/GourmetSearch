//
//  ThemeColor.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/23.
//

import SwiftUI

extension Color {
    static var myOrange: Color {
        Color(red: 1.0, green: 0.58, blue: 0.0)
    }

    static var myDarkOrange: Color {
        Color(red: 1.0, green: 0.20, blue: 0.0)
    }

    static var orangeButtonGradient: LinearGradient {
        LinearGradient(
            colors: [myOrange, myDarkOrange],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Theme Modifier
struct OrangeTheme {
    static func primaryButtonStyle() -> some ViewModifier {
        OrangePrimaryButtonStyle()
    }

    static func secondaryButtonStyle() -> some ViewModifier {
        OrangeSecondaryButtonStyle()
    }
}

// MARK: - Button Styles
struct OrangePrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.orangeButtonGradient)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.myOrange.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct OrangeSecondaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .foregroundColor(.myOrange)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.myOrange, lineWidth: 2)
            )
            .cornerRadius(12)
    }
}

// MARK: - View Extensions
extension View {
    func orangePrimaryButton() -> some View {
        modifier(OrangePrimaryButtonStyle())
    }

    func orangeSecondaryButton() -> some View {
        modifier(OrangeSecondaryButtonStyle())
    }
}
