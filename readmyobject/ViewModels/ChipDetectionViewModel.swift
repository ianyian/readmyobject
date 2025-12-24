//
//  ChipDetectionViewModel.swift
//  readmyobject
//
//  Created by XJ on 24/12/2025.
//

import Foundation
import SwiftUI
import Vision
import CoreML
import Combine

@MainActor
class ChipDetectionViewModel: ObservableObject {
    @Published var isProcessing = false
    @Published var detectionResult: DetectionResult?
    @Published var errorMessage: String?
    
    // Confidence threshold for detection (0.0 to 1.0)
    var confidenceThreshold: Float = 0.95
    
    // Detection mode for filtering objects
    var detectionMode: DetectionMode = .allObjects {
        didSet {
            // Reload model when detection mode changes
            loadModel()
        }
    }
    
    private var chipModel: VNCoreMLModel?  // Custom poker chip model
    private var standardModel: VNCoreMLModel?  // Standard YOLOv8 COCO model
    
    private var model: VNCoreMLModel? {
        // Use chip model only for poker chips mode
        if detectionMode == .pokerChips {
            return chipModel
        }
        // Use standard model for all other modes
        return standardModel ?? chipModel  // Fallback to chip model if standard not available
    }
    
    init() {
        loadModel()
    }
    
    /// Load the Core ML models
    private func loadModel() {
        let config = MLModelConfiguration()
        config.computeUnits = .all  // Use Neural Engine if available
        
        // Load custom poker chip model (best.mlpackage)
        if chipModel == nil {
            do {
                guard let chipModelURL = Bundle.main.url(forResource: "best", withExtension: "mlmodelc") else {
                    print("⚠️ Custom chip model (best.mlpackage) not found")
                    errorMessage = "Poker chip model not found. Please add best.mlpackage to Xcode project."
                    return
                }
                
                let mlModel = try MLModel(contentsOf: chipModelURL, configuration: config)
                chipModel = try VNCoreMLModel(for: mlModel)
                print("✅ Loaded custom poker chip model (best.mlpackage)")
            } catch {
                print("❌ Failed to load chip model: \(error.localizedDescription)")
            }
        }
        
        // Load standard YOLOv8 model (yolov8n.mlpackage)
        if standardModel == nil {
            do {
                guard let standardModelURL = Bundle.main.url(forResource: "yolov8n", withExtension: "mlmodelc") else {
                    print("⚠️ Standard YOLOv8 model (yolov8n.mlpackage) not found in Xcode project")
                    print("   File exists at: customModel/yolov8n.mlpackage")
                    print("   ❌ You must ADD it to Xcode:")
                    print("   1. Right-click readmyobject folder in Xcode")
                    print("   2. Add Files → Select yolov8n.mlpackage")
                    print("   3. Check 'Copy items if needed'")
                    print("   Using chip model as fallback (can only detect chips)")
                    return
                }
                
                let mlModel = try MLModel(contentsOf: standardModelURL, configuration: config)
                standardModel = try VNCoreMLModel(for: mlModel)
                print("✅ Loaded standard YOLOv8 model (yolov8n.mlpackage) - 80 COCO classes")
            } catch {
                print("❌ Failed to load standard model: \(error.localizedDescription)")
                print("   Will use chip model as fallback")
            }
        }
        
        // Log which model is active
        if detectionMode == .allObjects {
            if chipModel != nil && standardModel != nil {
                print("🎯 Using BOTH MODELS for All Objects detection")
            } else if standardModel != nil {
                print("🎯 Using STANDARD MODEL only for All Objects detection")
            } else if chipModel != nil {
                print("🎯 Using CHIP MODEL only for All Objects detection")
            }
        } else if detectionMode == .pokerChips {
            print("🎯 Using CHIP MODEL for poker chips detection")
        } else if standardModel != nil {
            print("🎯 Using STANDARD MODEL for \(detectionMode.displayName) detection")
        } else {
            print("⚠️ Standard model not available, using chip model")
        }
    }
    
    /// Detect poker chips in the provided image
    func detectChips(in image: UIImage) {
        // For "All Objects" mode, use both models
        if detectionMode == .allObjects {
            detectWithBothModels(in: image)
            return
        }
        
        guard let model = model else {
            if detectionMode == .pokerChips {
                errorMessage = "Poker chip model not loaded. Please add best.mlpackage to Xcode project."
            } else {
                errorMessage = "Standard YOLOv8 model not found. Please add yolov8n.mlpackage to Xcode project to detect \(detectionMode.displayName.lowercased())."
            }
            return
        }
        
        guard let ciImage = CIImage(image: image) else {
            errorMessage = "Failed to convert image"
            return
        }
        
        isProcessing = true
        errorMessage = nil
        
        let startTime = Date()
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isProcessing = false
                
                if let error = error {
                    self.errorMessage = "Detection failed: \(error.localizedDescription)"
                    return
                }
                
                guard let results = request.results as? [VNRecognizedObjectObservation] else {
                    self.errorMessage = "No results returned from model"
                    return
                }
                
                let processingTime = Date().timeIntervalSince(startTime)
                self.processResults(results, for: image, processingTime: processingTime)
            }
        }
        
        request.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        Task {
            do {
                try handler.perform([request])
            } catch {
                await MainActor.run {
                    self.isProcessing = false
                    self.errorMessage = "Detection error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// Detect using both models and combine results
    private func detectWithBothModels(in image: UIImage) {
        guard chipModel != nil || standardModel != nil else {
            errorMessage = "No models loaded. Please add models to Xcode project."
            return
        }
        
        guard let ciImage = CIImage(image: image) else {
            errorMessage = "Failed to convert image"
            return
        }
        
        isProcessing = true
        errorMessage = nil
        
        let startTime = Date()
        print("🔄 Running detection with BOTH models for All Objects mode")
        
        var allResults: [VNRecognizedObjectObservation] = []
        let dispatchGroup = DispatchGroup()
        
        // Run standard model detection
        if let standardModel = standardModel {
            dispatchGroup.enter()
            let standardRequest = VNCoreMLRequest(model: standardModel) { request, error in
                defer { dispatchGroup.leave() }
                
                if let error = error {
                    print("⚠️ Standard model error: \(error.localizedDescription)")
                    return
                }
                
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    print("✅ Standard model detected \(results.count) objects")
                    allResults.append(contentsOf: results)
                }
            }
            standardRequest.imageCropAndScaleOption = .scaleFill
            
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            Task {
                do {
                    try handler.perform([standardRequest])
                } catch {
                    print("❌ Standard model perform error: \(error.localizedDescription)")
                    dispatchGroup.leave()
                }
            }
        }
        
        // Run chip model detection
        if let chipModel = chipModel {
            dispatchGroup.enter()
            let chipRequest = VNCoreMLRequest(model: chipModel) { request, error in
                defer { dispatchGroup.leave() }
                
                if let error = error {
                    print("⚠️ Chip model error: \(error.localizedDescription)")
                    return
                }
                
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    print("✅ Chip model detected \(results.count) objects")
                    allResults.append(contentsOf: results)
                }
            }
            chipRequest.imageCropAndScaleOption = .scaleFill
            
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            Task {
                do {
                    try handler.perform([chipRequest])
                } catch {
                    print("❌ Chip model perform error: \(error.localizedDescription)")
                    dispatchGroup.leave()
                }
            }
        }
        
        // Wait for both models to complete
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            self.isProcessing = false
            let processingTime = Date().timeIntervalSince(startTime)
            
            print("🎯 Combined results from both models: \(allResults.count) total detections")
            self.processResults(allResults, for: image, processingTime: processingTime)
        }
    }
    
    /// Process detection results and create Detection objects
    private func processResults(_ results: [VNRecognizedObjectObservation], for image: UIImage, processingTime: TimeInterval) {
        var detections: [Detection] = []
        
        print("🔍 Processing \(results.count) observations")
        
        for observation in results {
            guard let label = observation.labels.first,
                  label.confidence >= confidenceThreshold else {
                continue
            }
            
            print("📊 Detected: '\(label.identifier)' with confidence \(label.confidence)")
            
            // Filter based on detection mode (only if not in all objects mode)
            if detectionMode != .allObjects && !detectionMode.matches(label: label.identifier) {
                print("❌ Filtered out: '\(label.identifier)' doesn't match mode \(detectionMode.displayName)")
                continue
            }
            
            print("✅ Accepted: '\(label.identifier)'")
            
            // Parse the class from label identifier
            let chipColor = parseChipColor(from: label.identifier)
            
            // Get human-readable label (try COCO mapping if numeric)
            let displayLabel: String
            if let classId = Int(label.identifier) {
                // Check if it's a COCO class ID (0-79) or custom chip class (0-3)
                if classId >= 0 && classId <= 79 {
                    displayLabel = cocoClassName(for: classId)
                } else {
                    displayLabel = label.identifier
                }
            } else {
                displayLabel = label.identifier
            }
            
            // Convert Vision coordinate system to UIKit coordinate system
            // Vision uses bottom-left origin, UIKit uses top-left
            let boundingBox = convertBoundingBox(observation.boundingBox, imageSize: image.size)
            
            let detection = Detection(
                boundingBox: boundingBox,
                label: displayLabel,
                chipColor: chipColor,
                confidence: label.confidence
            )
            
            print("🎯 Created detection: label='\(displayLabel)', box=\(boundingBox)")
            detections.append(detection)
        }
        
        print("📈 Total detections created: \(detections.count)")
        
        detectionResult = DetectionResult(
            detections: detections,
            image: image,
            processingTime: processingTime
        )
        
        print("✨ Detection complete - showing \(detectionResult!.totalChips) objects")
    }
    
    /// Parse chip color from label identifier
    private func parseChipColor(from identifier: String) -> ChipColor {
        let lowerIdentifier = identifier.lowercased()
        
        if lowerIdentifier.contains("black") {
            return .black
        } else if lowerIdentifier.contains("green") {
            return .green
        } else if lowerIdentifier.contains("red") {
            return .red
        } else if lowerIdentifier.contains("white") || lowerIdentifier.contains("blue") {
            return .whiteBlue
        } else {
            // Try parsing as class ID (for custom chip model: 0-3)
            if let classId = Int(identifier), let color = ChipColor(rawValue: classId) {
                return color
            }
            // Default fallback for non-chip objects
            return .black
        }
    }
    
    /// Map COCO class IDs to readable names (standard YOLOv8)
    private func cocoClassName(for classId: Int) -> String {
        let cocoClasses = [
            "person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat",
            "traffic light", "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat",
            "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe", "backpack",
            "umbrella", "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard", "sports ball",
            "kite", "baseball bat", "baseball glove", "skateboard", "surfboard", "tennis racket",
            "bottle", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple",
            "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake",
            "chair", "couch", "potted plant", "bed", "dining table", "toilet", "tv", "laptop",
            "mouse", "remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink",
            "refrigerator", "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"
        ]
        
        if classId >= 0 && classId < cocoClasses.count {
            return cocoClasses[classId]
        }
        return "object \(classId)"
    }
    
    /// Convert Vision bounding box to UIKit coordinates
    private func convertBoundingBox(_ box: CGRect, imageSize: CGSize) -> CGRect {
        let width = box.width * imageSize.width
        let height = box.height * imageSize.height
        let x = box.minX * imageSize.width
        let y = (1 - box.maxY) * imageSize.height  // Flip Y coordinate
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    /// Reset detection results
    func reset() {
        detectionResult = nil
        errorMessage = nil
    }
}
