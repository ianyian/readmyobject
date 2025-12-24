//
//  ChipDetection.swift
//  readmyobject
//
//  Created by XJ on 24/12/2025.
//

import Foundation
import CoreGraphics
import SwiftUI

/// Represents a single detected object
struct Detection: Identifiable, Equatable {
    let id = UUID()
    let boundingBox: CGRect
    let label: String  // The actual detected label from YOLO
    let chipColor: ChipColor  // For backward compatibility with poker chips
    let confidence: Float
    
    static func == (lhs: Detection, rhs: Detection) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Returns a color for drawing the bounding box
    var boxColor: Color {
        chipColor.boxColor
    }
    
    /// Display name for the detected object
    var displayLabel: String {
        label.capitalized
    }
    
    /// Returns formatted confidence string
    var confidenceString: String {
        String(format: "%.1f%%", confidence * 100)
    }
}

/// Poker chip color types
enum ChipColor: Int, CaseIterable {
    case black = 0
    case green = 1
    case red = 2
    case whiteBlue = 3
    
    var displayName: String {
        switch self {
        case .black: return "Black"
        case .green: return "Green"
        case .red: return "Red"
        case .whiteBlue: return "White-Blue"
        }
    }
    
    var fullName: String {
        switch self {
        case .black: return "Black poker chips"
        case .green: return "Green poker chips"
        case .red: return "Red poker chips"
        case .whiteBlue: return "White-blue poker chips"
        }
    }
    
    var boxColor: Color {
        switch self {
        case .black: return Color(red: 1.0, green: 1.0, blue: 1.0) // Always white for visibility
        case .green: return Color(red: 0.0, green: 0.8, blue: 0.2) // Bright green
        case .red: return Color(red: 1.0, green: 0.2, blue: 0.2) // Bright red
        case .whiteBlue: return Color(red: 0.2, green: 0.6, blue: 1.0) // Bright blue
        }
    }
    
    /// Color for UI elements (adapts to dark mode)
    var uiColor: Color {
        switch self {
        case .black: return Color.primary
        case .green: return Color.green
        case .red: return Color.red
        case .whiteBlue: return Color.blue
        }
    }
    
    var icon: String {
        switch self {
        case .black: return "⚫"
        case .green: return "🟢"
        case .red: return "🔴"
        case .whiteBlue: return "⚪"
        }
    }
}

/// Summary of detection results
struct DetectionResult: Equatable {
    let detections: [Detection]
    let image: UIImage
    let processingTime: TimeInterval
    
    static func == (lhs: DetectionResult, rhs: DetectionResult) -> Bool {
        lhs.detections == rhs.detections && lhs.processingTime == rhs.processingTime
    }
    
    var totalChips: Int {
        detections.count
    }
    
    /// Count chips by color (for poker chips mode)
    var chipCounts: [ChipColor: Int] {
        var counts: [ChipColor: Int] = [:]
        for color in ChipColor.allCases {
            counts[color] = detections.filter { $0.chipColor == color }.count
        }
        return counts
    }
    
    /// Count detections by label (for all detection modes)
    var labelCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for detection in detections {
            let label = detection.displayLabel
            counts[label, default: 0] += 1
        }
        return counts
    }
    
    /// Get sorted labels by count (most common first)
    var sortedLabelCounts: [(label: String, count: Int)] {
        labelCounts.sorted { $0.value > $1.value }.map { (label: $0.key, count: $0.value) }
    }
    
    /// Get detections for a specific color
    func detections(for color: ChipColor) -> [Detection] {
        detections.filter { $0.chipColor == color }
    }
}
