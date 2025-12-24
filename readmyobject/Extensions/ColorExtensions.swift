//
//  ColorExtensions.swift
//  readmyobject
//
//  Created by XJ on 24/12/2025.
//

import SwiftUI

extension Color {
    /// Adaptive background colors for dark mode
    static let adaptiveBackground = Color(UIColor.systemBackground)
    static let adaptiveSecondaryBackground = Color(UIColor.secondarySystemBackground)
    static let adaptiveTertiaryBackground = Color(UIColor.tertiarySystemBackground)
    
    /// Adaptive text colors
    static let adaptiveLabel = Color(UIColor.label)
    static let adaptiveSecondaryLabel = Color(UIColor.secondaryLabel)
    static let adaptiveTertiaryLabel = Color(UIColor.tertiaryLabel)
    
    /// Adaptive separator
    static let adaptiveSeparator = Color(UIColor.separator)
    
    /// Custom colors that work well in both light and dark mode
    struct ChipDetector {
        static let primaryAccent = Color.blue
        static let secondaryAccent = Color.green
        
        // Detection box colors (always bright for visibility on photos)
        static let blackChipBox = Color.white
        static let greenChipBox = Color(red: 0.0, green: 0.9, blue: 0.3)
        static let redChipBox = Color(red: 1.0, green: 0.3, blue: 0.3)
        static let blueChipBox = Color(red: 0.3, green: 0.6, blue: 1.0)
        
        // Card backgrounds
        static let cardBackground = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.secondarySystemBackground
                : UIColor.systemBackground
        })
        
        static let highlightBackground = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.tertiarySystemBackground
                : UIColor.secondarySystemBackground
        })
    }
}

extension LinearGradient {
    /// Gradient for headers that adapts to dark mode
    static var adaptiveHeader: LinearGradient {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.3),
                Color.blue.opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
