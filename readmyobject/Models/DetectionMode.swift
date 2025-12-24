//
//  DetectionMode.swift
//  readmyobject
//
//  Created by XJ on 24/12/2025.
//

import Foundation
import SwiftUI

/// Detection mode for object detection
enum DetectionMode: String, CaseIterable, Identifiable {
    case allObjects = "all"
    case pokerChips = "chips"
    case person = "person"
    case car = "car"
    case dog = "dog"
    case cat = "cat"
    case bicycle = "bicycle"
    case motorcycle = "motorcycle"
    case bird = "bird"
    case horse = "horse"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .allObjects: return "All Objects"
        case .pokerChips: return "Poker Chips"
        case .person: return "Person"
        case .car: return "Car"
        case .dog: return "Dog"
        case .cat: return "Cat"
        case .bicycle: return "Bicycle"
        case .motorcycle: return "Motorcycle"
        case .bird: return "Bird"
        case .horse: return "Horse"
        }
    }
    
    var icon: String {
        switch self {
        case .allObjects: return "square.grid.3x3.fill"
        case .pokerChips: return "circlebadge.2.fill"
        case .person: return "person.fill"
        case .car: return "car.fill"
        case .dog: return "dog.fill"
        case .cat: return "cat.fill"
        case .bicycle: return "bicycle"
        case .motorcycle: return "motorcycle.fill"
        case .bird: return "bird.fill"
        case .horse: return "hare.fill"
        }
    }
    
    var description: String {
        switch self {
        case .allObjects:
            return "Detects all objects trained in the YOLOv8 model including people, vehicles, animals, and poker chips."
        case .pokerChips:
            return "Detects poker chips in four colors: Black, Green, Red, and White-Blue. Perfect for counting chips during games."
        case .person:
            return "Detects people in images. Useful for counting people or identifying human presence."
        case .car:
            return "Detects cars and automobiles. Can identify vehicles in traffic or parking scenarios."
        case .dog:
            return "Detects dogs of various breeds and sizes."
        case .cat:
            return "Detects cats of various breeds and sizes."
        case .bicycle:
            return "Detects bicycles and bikes in images."
        case .motorcycle:
            return "Detects motorcycles and motorbikes."
        case .bird:
            return "Detects birds of various species."
        case .horse:
            return "Detects horses and ponies."
        }
    }
    
    var headerTitle: String {
        switch self {
        case .allObjects: return "Object Detector"
        case .pokerChips: return "Poker Chip Detector"
        case .person: return "Person Detector"
        case .car: return "Car Detector"
        case .dog: return "Dog Detector"
        case .cat: return "Cat Detector"
        case .bicycle: return "Bicycle Detector"
        case .motorcycle: return "Motorcycle Detector"
        case .bird: return "Bird Detector"
        case .horse: return "Horse Detector"
        }
    }
    
    var headerSubtitle: String {
        switch self {
        case .allObjects: return "Detect and identify multiple object types"
        case .pokerChips: return "Detect and count poker chips by color"
        case .person: return "Detect and count people in images"
        case .car: return "Detect and identify cars"
        case .dog: return "Detect dogs in images"
        case .cat: return "Detect cats in images"
        case .bicycle: return "Detect bicycles in images"
        case .motorcycle: return "Detect motorcycles in images"
        case .bird: return "Detect birds in images"
        case .horse: return "Detect horses in images"
        }
    }
    
    /// Get the class labels associated with this detection mode
    var classLabels: Set<String> {
        switch self {
        case .allObjects:
            return Set() // Empty set means detect all
        case .pokerChips:
            return Set(["black", "green", "red", "white", "blue", "chip"])
        case .person:
            return Set(["person", "people", "human"])
        case .car:
            return Set(["car", "automobile", "vehicle"])
        case .dog:
            return Set(["dog"])
        case .cat:
            return Set(["cat"])
        case .bicycle:
            return Set(["bicycle", "bike"])
        case .motorcycle:
            return Set(["motorcycle", "motorbike"])
        case .bird:
            return Set(["bird"])
        case .horse:
            return Set(["horse", "pony"])
        }
    }
    
    /// Check if a label matches this detection mode
    func matches(label: String) -> Bool {
        if self == .allObjects {
            return true // All objects mode accepts everything
        }
        
        let lowerLabel = label.lowercased()
        return classLabels.contains { lowerLabel.contains($0) }
    }
}
