//
//  DetectionResultView.swift
//  readmyobject
//
//  Created by XJ on 24/12/2025.
//

import SwiftUI

struct DetectionResultView: View {
    let result: DetectionResult
    let showConfidence: Bool
    @State private var imageSize: CGSize = .zero
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image with bounding boxes
                GeometryReader { geometry in
                    ZStack {
                        Image(uiImage: result.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(
                                GeometryReader { imageGeometry in
                                    Color.clear
                                        .preference(
                                            key: ImageSizePreferenceKey.self,
                                            value: imageGeometry.size
                                        )
                                }
                            )
                        
                        // Draw bounding boxes
                        if imageSize != .zero && showConfidence {
                            ForEach(result.detections) { detection in
                                BoundingBoxView(
                                    detection: detection,
                                    imageSize: result.image.size,
                                    displaySize: imageSize,
                                    showConfidence: showConfidence
                                )
                            }
                        }
                        
                        // Label overlay (like live detection)
                        if imageSize != .zero && !result.sortedLabelCounts.isEmpty {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(result.sortedLabelCounts.prefix(5), id: \.label) { item in
                                            HStack(spacing: 8) {
                                                Text(item.label)
                                                    .font(.caption.weight(.semibold))
                                                Text("\(item.count)")
                                                    .font(.caption.weight(.bold))
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color.green)
                                                    .cornerRadius(4)
                                            }
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.black.opacity(0.7))
                                            .cornerRadius(8)
                                        }
                                    }
                                    .padding(.leading, 16)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .aspectRatio(result.image.size.width / result.image.size.height, contentMode: .fit)
                .onPreferenceChange(ImageSizePreferenceKey.self) { size in
                    imageSize = size
                }
                
                // Detection summary
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.blue)
                        Text("Total Objects Detected")
                            .font(.headline)
                        Spacer()
                        Text("\(result.totalChips)")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
                    
                    Divider()
                    
                    // Processing time
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("Processing Time")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(String(format: "%.2f seconds", result.processingTime))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .padding()
        }
        .navigationTitle("Detection Results")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// Returns an appropriate SF Symbol icon for a detected label
    private func iconForLabel(_ label: String) -> String {
        let lowerLabel = label.lowercased()
        
        // Poker chips
        if lowerLabel.contains("chip") || lowerLabel.contains("black") || 
           lowerLabel.contains("green") || lowerLabel.contains("red") || 
           lowerLabel.contains("white") || lowerLabel.contains("blue") {
            return "circlebadge.2.fill"
        }
        
        // People
        if lowerLabel.contains("person") || lowerLabel.contains("people") || lowerLabel.contains("human") {
            return "person.fill"
        }
        
        // Vehicles
        if lowerLabel.contains("car") || lowerLabel.contains("automobile") {
            return "car.fill"
        }
        if lowerLabel.contains("bicycle") || lowerLabel.contains("bike") {
            return "bicycle"
        }
        if lowerLabel.contains("motorcycle") || lowerLabel.contains("motorbike") {
            return "motorcycle.fill"
        }
        if lowerLabel.contains("bus") {
            return "bus.fill"
        }
        if lowerLabel.contains("truck") {
            return "truck.box.fill"
        }
        
        // Animals
        if lowerLabel.contains("dog") {
            return "dog.fill"
        }
        if lowerLabel.contains("cat") {
            return "cat.fill"
        }
        if lowerLabel.contains("bird") {
            return "bird.fill"
        }
        if lowerLabel.contains("horse") {
            return "hare.fill"
        }
        
        // Objects
        if lowerLabel.contains("bottle") {
            return "waterbottle.fill"
        }
        if lowerLabel.contains("chair") {
            return "chair.fill"
        }
        if lowerLabel.contains("book") {
            return "book.fill"
        }
        
        // Default
        return "cube.fill"
    }
}

/// Draws a single bounding box with label
struct BoundingBoxView: View {
    let detection: Detection
    let imageSize: CGSize
    let displaySize: CGSize
    let showConfidence: Bool
    
    private var scaledBox: CGRect {
        let scaleX = displaySize.width / imageSize.width
        let scaleY = displaySize.height / imageSize.height
        
        return CGRect(
            x: detection.boundingBox.origin.x * scaleX,
            y: detection.boundingBox.origin.y * scaleY,
            width: detection.boundingBox.width * scaleX,
            height: detection.boundingBox.height * scaleY
        )
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Bounding box
            Rectangle()
                .stroke(detection.boxColor, lineWidth: 3)
                .frame(width: scaledBox.width, height: scaledBox.height)
                .position(
                    x: scaledBox.midX,
                    y: scaledBox.midY
                )
            
            // Label
            Text(showConfidence ? "\(detection.displayLabel) \(detection.confidenceString)" : detection.displayLabel)
                .font(.caption.weight(.bold))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(detection.boxColor.opacity(0.9))
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                )
                .foregroundColor(.white)
                .position(
                    x: scaledBox.minX + scaledBox.width / 2,
                    y: scaledBox.minY - 14
                )
        }
    }
}

/// Preference key for capturing image size
struct ImageSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

#Preview {
    NavigationView {
        DetectionResultView(
            result: DetectionResult(
                detections: [
                    Detection(
                        boundingBox: CGRect(x: 50, y: 50, width: 100, height: 100),
                        label: "red chip",
                        chipColor: .red,
                        confidence: 0.92
                    ),
                    Detection(
                        boundingBox: CGRect(x: 200, y: 150, width: 100, height: 100),
                        label: "black chip",
                        chipColor: .black,
                        confidence: 0.88
                    )
                ],
                image: UIImage(systemName: "photo")!,
                processingTime: 0.234
            ),
            showConfidence: true
        )
    }
}
