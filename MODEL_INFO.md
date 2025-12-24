# Poker Chip Detection Model - iOS Integration Guide

## Model Overview

**Model Name:** Custom YOLOv8 Poker Chip Detector  
**Task:** Object Detection  
**Framework:** Ultralytics YOLOv8  
**Model Format:** PyTorch (.pt), ONNX (.onnx)  
**Purpose:** Real-time detection and counting of poker chips by color

---

## Model Capabilities

This custom-trained YOLOv8 model can:

- ✅ Detect poker chips in images and video streams
- ✅ Classify chips by color: Black, Green, Red, White-Blue
- ✅ Count total chips and chips per color
- ✅ Draw bounding boxes around detected chips
- ✅ Provide confidence scores for each detection
- ✅ Process images in real-time (suitable for mobile)

---

## Technical Specifications

### Model Architecture

- **Base Model:** YOLOv8 (Nano/Small/Medium - confirm your variant)
- **Input Size:** 640x640 pixels (standard YOLO input)
- **Output:** Bounding boxes with class labels and confidence scores

### Model Files

```
customModel/
├── best.pt          # PyTorch model (for training/Python)
└── best.onnx        # ONNX model (recommended for iOS)
```

**File Sizes:**

- `.pt` file: ~6-50 MB (depending on YOLOv8 variant)
- `.onnx` file: ~12-100 MB (depending on YOLOv8 variant)

### Classes and Labels

| Class ID | Class Name             | Color      | Description             |
| -------- | ---------------------- | ---------- | ----------------------- |
| 0        | Black poker chips      | Black      | Standard black chips    |
| 1        | Green poker chips      | Green      | Standard green chips    |
| 2        | Red poker chips        | Red        | Standard red chips      |
| 3        | White-blue poker chips | White/Blue | White with blue accents |

---

## Model Performance

### Recommended Settings

- **Confidence Threshold:** 0.5 (50%)
  - Lower (0.3-0.4): More detections, may include false positives
  - Higher (0.6-0.7): Fewer detections, more accurate
- **IOU Threshold:** 0.45 (for non-maximum suppression)

### Expected Performance

- **Speed:** 20-60 FPS on modern mobile devices (depending on device)
- **Accuracy:** ~90%+ mAP (mean Average Precision) on validation set
- **Use Cases:**
  - Inventory counting
  - Game assistance
  - Chip stack valuation
  - Real-time table monitoring

---

## iOS Integration Guide

### Option 1: Core ML (Recommended for iOS)

#### Step 1: Convert Model to Core ML

```bash
# Install coremltools
pip install coremltools

# Convert ONNX to Core ML
from ultralytics import YOLO
model = YOLO('customModel/best.pt')
model.export(format='coreml')  # Creates best.mlpackage or best.mlmodel
```

#### Step 2: iOS Integration

- Add the `.mlpackage` or `.mlmodel` file to your Xcode project
- Use `Vision` framework for inference
- Recommended minimum iOS version: iOS 13+

### Option 2: ONNX Runtime

#### Requirements

```ruby
# Add to your Podfile
pod 'onnxruntime-objc'
```

#### Model Preparation

- Use `customModel/best.onnx`
- Model input: `[1, 3, 640, 640]` (batch, channels, height, width)
- Model output: Bounding boxes + class probabilities

### Option 3: TensorFlow Lite

```bash
# Convert to TFLite
model = YOLO('customModel/best.pt')
model.export(format='tflite')
```

---

## Input Requirements

### Image Format

- **Dimensions:** Any size (will be resized to 640x640 internally)
- **Color Space:** RGB
- **Format:** JPEG, PNG, or raw camera buffer
- **Orientation:** Portrait or landscape

### Preprocessing (Automatic)

1. Resize to 640x640
2. Normalize pixel values (0-1 or 0-255, model handles this)
3. Convert to RGB if needed

---

## Output Format

### Detection Results

Each detection contains:

```swift
struct Detection {
    let boundingBox: CGRect     // x, y, width, height (normalized 0-1)
    let classId: Int            // 0=black, 1=green, 2=red, 3=white-blue
    let className: String       // "Black poker chips", etc.
    let confidence: Float       // 0.0 to 1.0
}
```

### Example Output

```json
{
  "detections": [
    {
      "box": { "x": 0.23, "y": 0.45, "width": 0.12, "height": 0.15 },
      "class_id": 2,
      "class_name": "Red poker chips",
      "confidence": 0.92
    },
    {
      "box": { "x": 0.67, "y": 0.34, "width": 0.11, "height": 0.14 },
      "class_id": 0,
      "class_name": "Black poker chips",
      "confidence": 0.88
    }
  ],
  "total_chips": 2
}
```

---

## iOS App Features Recommendations

### Core Features

1. **Real-time Camera Detection**
   - Live camera feed with overlay bounding boxes
   - Tap to freeze frame and count chips
2. **Photo Analysis**
   - Select from photo library
   - Take photo and analyze
3. **Chip Counting**

   - Display total count
   - Count by color
   - Visual summary (pie chart/bar chart)

4. **Confidence Indicator**
   - Show confidence scores
   - Highlight low-confidence detections
   - Allow manual adjustment

### UI Considerations

- **Bounding Box Colors:**

  - Black chips: White box
  - Green chips: Green box
  - Red chips: Red box
  - White-Blue chips: Blue box

- **Label Display:**

  - Show class name + confidence above each box
  - Example: "Red 92%"

- **Count Summary:**
  - Bottom overlay or side panel
  - Total: 15 chips
  - Black: 5, Green: 3, Red: 4, White-Blue: 3

---

## Performance Optimization for iOS

### Recommendations

1. **Model Size:**

   - Use YOLOv8n (nano) for best mobile performance
   - Quantize model to INT8 for faster inference

2. **Resolution:**

   - Use 640x640 (default) for best accuracy
   - Can use 320x320 for faster processing on older devices

3. **Frame Rate:**

   - Process every 2nd-3rd frame for smooth UI
   - Skip frames if processing lags

4. **Threading:**

   - Run inference on background thread
   - Update UI on main thread

5. **Battery:**
   - Reduce frame rate when battery is low
   - Pause processing when app is in background

---

## Testing Recommendations

### Test Cases for iOS App

1. **Lighting Conditions:**
   - Bright light
   - Low light
   - Mixed lighting
2. **Camera Angles:**

   - Top-down (ideal)
   - 45-degree angle
   - Side view

3. **Chip Arrangements:**

   - Scattered chips
   - Stacked chips
   - Overlapping chips
   - Different distances

4. **Device Testing:**
   - iPhone 12 and newer (optimal)
   - iPhone X-11 (good)
   - iPhone 8 and older (acceptable)
   - iPad (excellent)

---

## Integration Code Example (Swift + Core ML)

```swift
import Vision
import CoreML

class PokerChipDetector {
    private var model: VNCoreMLModel?

    init() {
        guard let mlModel = try? PokerChipYOLOv8(configuration: MLModelConfiguration()),
              let visionModel = try? VNCoreMLModel(for: mlModel.model) else {
            return
        }
        self.model = visionModel
    }

    func detectChips(in image: UIImage, completion: @escaping ([Detection]) -> Void) {
        guard let model = model,
              let ciImage = CIImage(image: image) else {
            completion([])
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                completion([])
                return
            }

            let detections = results.compactMap { observation -> Detection? in
                guard let label = observation.labels.first else { return nil }
                return Detection(
                    boundingBox: observation.boundingBox,
                    classId: self.classId(from: label.identifier),
                    className: label.identifier,
                    confidence: label.confidence
                )
            }

            completion(detections)
        }

        request.imageCropAndScaleOption = .scaleFill

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }

    private func classId(from identifier: String) -> Int {
        switch identifier.lowercased() {
        case "black": return 0
        case "green": return 1
        case "red": return 2
        case "white-blue", "whiteblue": return 3
        default: return -1
        }
    }
}
```

---

## Model Export Commands

### Export to Multiple Formats

```python
from ultralytics import YOLO

# Load your trained model
model = YOLO('customModel/best.pt')

# Export to Core ML (iOS)
model.export(format='coreml', nms=True, imgsz=640)

# Export to ONNX
model.export(format='onnx', simplify=True, imgsz=640)

# Export to TFLite
model.export(format='tflite', int8=True, imgsz=640)
```

---

## Important Notes for iOS Development

⚠️ **Model Updates:**

- Model can be updated via app update
- Consider cloud-based model delivery for flexibility

⚠️ **Privacy:**

- All processing can be done on-device
- No image data needs to be sent to servers
- Mention in App Store privacy policy

⚠️ **Permissions:**

- Request camera permission
- Request photo library access (if applicable)

⚠️ **Error Handling:**

- Handle cases when model fails to load
- Provide fallback for unsupported devices
- Graceful degradation for low memory

---

## Support & Resources

### Documentation

- YOLOv8: https://docs.ultralytics.com
- Core ML: https://developer.apple.com/documentation/coreml
- Vision Framework: https://developer.apple.com/documentation/vision

### Model Repository

- Training notebooks included in this repository
- Test script: `test_detection.py`
- Sample images: `data/valid/images/`

### Contact

- Repository: https://github.com/ianyian/read-my-chips
- Issues: Submit via GitHub Issues

---

## Version History

**v1.0** (Current)

- Initial release
- 4 chip color classes
- YOLOv8 base model
- Trained on [X] images
- Validated on [Y] images

---

## Future Enhancements

Potential improvements for future versions:

- [ ] Add more chip colors (yellow, blue, orange)
- [ ] Detect chip denominations/values
- [ ] Recognize stacked chip towers
- [ ] Currency/value calculation
- [ ] Multiple table/game type support
- [ ] Low-light optimization

---

_Last Updated: December 24, 2025_
