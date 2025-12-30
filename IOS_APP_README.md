# my1314 - iOS App

An educational iOS application that uses custom YOLOv8 machine learning model to demonstrate AI object detection and counting in real-time.

**Educational Purpose:** This app is designed for learning and exploring YOLOv8 COCO object detection technology.

## 🎯 Features

### Core Functionality

- 📸 **Camera Capture**: Take photos using iPhone back camera
- 🖼️ **Photo Library**: Analyze existing photos from library
- 🤖 **AI Detection**: Powered by custom YOLOv8 Core ML model
- 🎨 **Visual Results**: Bounding boxes with color-coded labels
- 📊 **Detailed Counts**: Total chips and breakdown by color
- ⚡ **Fast Processing**: Optimized for iOS Neural Engine

### Detected Chip Colors (Educational Model)

- ⚫ **Black** chips
- 🟢 **Green** chips
- 🔴 **Red** chips
- ⚪ **White-Blue** chips

## 📱 Screenshots & UI

### Main Screen

- Welcome screen with app branding
- Two main action buttons:
  - "Take Photo" (blue) - Opens camera
  - "Choose from Library" (green) - Opens photo picker
- Color legend showing detectable chip types

### Detection Results Screen

- Original image with overlaid bounding boxes
- Each detection labeled with:
  - Chip color name
  - Confidence percentage
- Summary card showing:
  - Total chips detected
  - Breakdown by color with icons
  - Processing time

## 🏗️ Architecture

### SwiftUI + MVVM Pattern

```
┌─────────────────────────────────────┐
│          ContentView.swift          │  Main UI & Navigation
│  (Coordinator for camera & results) │
└─────────────────────────────────────┘
              │
              ├─────────────────────────┐
              │                         │
┌─────────────▼─────────┐  ┌───────────▼──────────┐
│ CameraView.swift      │  │ ChipDetectionVM      │
│ PhotoPicker.swift     │  │ (Vision + Core ML)   │
└───────────────────────┘  └──────────────────────┘
                                      │
                           ┌──────────▼──────────┐
                           │ best.mlpackage      │
                           │ (YOLOv8 Core ML)    │
                           └─────────────────────┘
```

### Components

#### **Models/** (`ChipDetection.swift`)

- `Detection` - Single chip detection with bounding box, color, confidence
- `ChipColor` - Enum for chip types with display properties
- `DetectionResult` - Complete detection session with statistics

#### **ViewModels/** (`ChipDetectionViewModel.swift`)

- Loads Core ML model
- Processes images using Vision framework
- Converts model output to Detection objects
- Handles errors and loading states

#### **Views/**

- `CameraView.swift` - UIKit camera wrapper for SwiftUI
- `DetectionResultView.swift` - Results display with bounding boxes
- `ContentView.swift` - Main app coordinator

## 🛠️ Technical Details

### Requirements

- **iOS:** 15.0+
- **Xcode:** 14.0+
- **Swift:** 5.0+
- **Frameworks:**
  - SwiftUI
  - Vision
  - Core ML
  - UIKit (Camera)

### Model Integration

- **Format:** Core ML (.mlpackage)
- **Input:** 640×640 RGB image
- **Output:** Bounding boxes with class labels
- **Inference:** Vision framework with VNCoreMLRequest
- **Hardware:** Neural Engine, GPU, or CPU

### Performance

- **Inference Time:** 0.1-0.5 seconds (device dependent)
- **Frame Rate:** Suitable for real-time video (20-60 FPS)
- **Model Size:** ~6-50 MB (depending on YOLOv8 variant)
- **Memory:** Minimal impact, runs on all modern iPhones

## 📂 File Structure

```
readmyobject/
├── Models/
│   └── ChipDetection.swift           # Data models
├── ViewModels/
│   └── ChipDetectionViewModel.swift  # Detection logic
├── Views/
│   ├── CameraView.swift              # Camera capture
│   └── DetectionResultView.swift     # Results display
├── ContentView.swift                 # Main UI
├── readmyobjectApp.swift            # App entry point
├── Info.plist                        # Permissions
└── Assets.xcassets/                  # App assets
```

## 🔒 Privacy & Permissions

### Required Permissions

- **Camera**: Capture photos for chip detection
- **Photo Library**: Select existing photos to analyze

### Privacy Features

- ✅ All processing done on-device
- ✅ No data sent to servers
- ✅ No image storage without user action
- ✅ Clear permission descriptions

## 🎨 Design Highlights

### Color Scheme

- **Primary:** Blue (main actions)
- **Secondary:** Green (alternative actions)
- **Accent:** Color-coded by chip type
- **Background:** Light/adaptive

### Typography

- **Headers:** Bold system font
- **Body:** Regular system font
- **Labels:** Semibold for emphasis

### UI/UX

- Large, tappable buttons
- Clear visual hierarchy
- Loading indicators
- Error alerts
- Dismissible sheets

## 🚀 Setup & Installation

See [QUICK_START.md](QUICK_START.md) for 5-minute setup or [IOS_SETUP_GUIDE.md](IOS_SETUP_GUIDE.md) for detailed instructions.

**Quick Version:**

1. Convert model: `python convert_to_coreml.py`
2. Open Xcode: `open readmyobject.xcodeproj`
3. Add `best.mlpackage` to project
4. Add all Swift files to project
5. Build & Run

## 📊 Model Details

### YOLOv8 Custom Educational Model

- **Purpose:** Educational demonstration of AI object detection
- **Trained on:** Custom chip dataset for learning purposes
- **Classes:** 4 (Black, Green, Red, White-Blue)
- **Architecture:** YOLOv8 (Ultralytics)
- **Accuracy:** ~90%+ mAP on validation set
- **Confidence Threshold:** 0.5 (configurable)
- **Technology:** YOLOv8 COCO-based detection

See [MODEL_INFO.md](MODEL_INFO.md) for complete model documentation.

## 🧪 Testing

### Recommended Test Cases

1. **Lighting conditions:** Bright, indoor, low-light
2. **Camera angles:** Top-down, 45°, side view
3. **Chip arrangements:** Scattered, stacked, mixed
4. **Distances:** Close-up, medium, far

### Test Data

Use validation images from `data/valid/images/`:

- Import to iOS photo library
- Test with "Choose from Library"
- Verify detection accuracy

## 🐛 Known Limitations

- Overlapping objects may be counted as one
- Very low lighting reduces accuracy
- Extreme angles affect detection
- Minimum object size for detection
- Best results with top-down view

**Note:** This is an educational demonstration app for learning AI object detection concepts.

## 🔮 Future Enhancements

### Planned Features (Educational Improvements)

- [ ] Real-time video detection
- [ ] Adjustable confidence slider
- [ ] Save results to Photos
- [ ] Export as CSV/JSON
- [ ] Educational tutorials on AI detection
- [ ] Detection history
- [ ] More object types support
- [ ] Dark mode optimization
- [ ] iPad specific layout
- [ ] Share results feature

### Advanced Features

- [ ] AR overlay in camera view
- [ ] Stack counting (multiple layers)
- [ ] Currency conversion
- [ ] Multi-table support
- [ ] Batch processing
- [ ] Cloud sync (optional)

## 📝 Code Examples

### Basic Usage

```swift
// Initialize view model
let viewModel = ChipDetectionViewModel()

// Detect chips in image
viewModel.detectChips(in: capturedImage)

// Access results
if let result = viewModel.detectionResult {
    print("Total chips: \(result.totalChips)")
    print("Red chips: \(result.chipCounts[.red] ?? 0)")
}
```

### Adjust Confidence

```swift
// In ChipDetectionViewModel
var confidenceThreshold: Float = 0.3  // More detections
var confidenceThreshold: Float = 0.7  // Higher accuracy
```

### Custom Processing

```swift
// Filter detections by color
let redChips = result.detections(for: .red)
let highConfidence = result.detections.filter { $0.confidence > 0.8 }
```

## 🤝 Contributing

Contributions welcome! Areas for improvement:

- UI/UX enhancements
- Performance optimizations
- Additional features
- Bug fixes
- Documentation

## 📄 License

MIT License - See main [README.md](README.md)

## 🙏 Acknowledgments

- **YOLOv8:** Ultralytics
- **Core ML:** Apple
- **Vision Framework:** Apple
- **SwiftUI:** Apple

## 📞 Support

- **Documentation:** [IOS_SETUP_GUIDE.md](IOS_SETUP_GUIDE.md)
- **Model Info:** [MODEL_INFO.md](MODEL_INFO.md)
- **Quick Start:** [QUICK_START.md](QUICK_START.md)
- **Issues:** GitHub Issues
- **Discussions:** GitHub Discussions

---

**Built with ❤️ for AI learning and education**

_Version 1.0 - December 31, 2025_
