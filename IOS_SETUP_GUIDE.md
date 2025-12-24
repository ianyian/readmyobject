# iOS Poker Chip Detector - Setup Guide

This guide will help you set up and run the iOS poker chip detection app.

## 📋 Prerequisites

- macOS with Xcode 14.0 or later
- iOS device or simulator running iOS 15.0 or later
- Python 3.8+ (for model conversion)
- The trained YOLOv8 model (`customModel/best.pt`)

## 🚀 Setup Steps

### Step 1: Convert Model to Core ML Format

Before opening Xcode, you need to convert the PyTorch model to Core ML format.

```bash
# Make sure you're in the project directory
cd /Users/xj/git/readmyobject

# Install required Python packages
pip install ultralytics coremltools

# Run the conversion script
python convert_to_coreml.py
```

This will create `customModel/best.mlpackage` which is compatible with iOS.

**Expected Output:**

```
Loading model from customModel/best.pt...
Converting to Core ML format...
This may take a few minutes...

✅ Conversion complete!
Core ML model saved as: customModel/best.mlpackage
```

### Step 2: Add Model to Xcode Project

1. Open Xcode project:

   ```bash
   open readmyobject.xcodeproj
   ```

2. In Xcode, drag and drop `customModel/best.mlpackage` into the project navigator

3. In the dialog that appears:

   - ✅ Check "Copy items if needed"
   - ✅ Check "Create groups"
   - ✅ Make sure "readmyobject" target is selected
   - Click "Finish"

4. Select the `best.mlpackage` file in Xcode to view model details

### Step 3: Configure Info.plist

The `Info.plist` file has been created with camera and photo library permissions. You need to add it to your Xcode project:

1. In Xcode, select the `readmyobject` project in the navigator
2. Select the `readmyobject` target
3. Go to the "Info" tab
4. You should see these entries (if not, add them manually):
   - **Privacy - Camera Usage Description**: "We need access to your camera to capture photos of poker chips for detection and counting."
   - **Privacy - Photo Library Usage Description**: "We need access to your photo library to analyze images of poker chips."

Alternatively, you can use the existing `Info.plist` file:

- In Xcode project navigator, right-click on the `readmyobject` folder
- Select "Add Files to readmyobject..."
- Navigate to and select `readmyobject/Info.plist`

### Step 4: Add New Files to Xcode

Add all the newly created Swift files to your Xcode project:

1. **Models folder:**

   - Right-click on `readmyobject` folder → New Group → Name it "Models"
   - Add `ChipDetection.swift` to this group

2. **ViewModels folder:**

   - Right-click on `readmyobject` folder → New Group → Name it "ViewModels"
   - Add `ChipDetectionViewModel.swift` to this group

3. **Views folder:**
   - Right-click on `readmyobject` folder → New Group → Name it "Views"
   - Add `CameraView.swift` to this group
   - Add `DetectionResultView.swift` to this group

**To add files:**

- Drag and drop the files into the appropriate groups in Xcode, OR
- Right-click group → "Add Files to readmyobject..." → Select files

Make sure all files are checked under the `readmyobject` target.

### Step 5: Update Model Name (if needed)

If your model is named differently or Xcode generates a different class name:

1. Open `best.mlpackage` in Xcode
2. Note the "Model Class" name (usually `best` or similar)
3. If different, update `ChipDetectionViewModel.swift`:

```swift
// In loadModel() function, update this line if needed:
guard let modelURL = Bundle.main.url(forResource: "best", withExtension: "mlmodelc") else {
```

### Step 6: Build and Run

1. Select your target device or simulator
2. Click the "Run" button (▶️) or press `Cmd + R`
3. First launch will ask for camera and photo library permissions - grant them

## 📱 Using the App

### Main Screen

- **Take Photo**: Opens camera to capture a new photo
- **Choose from Library**: Selects existing photo from library

### After Capture

1. Photo is automatically sent to the model for detection
2. Processing overlay shows while detecting
3. Results screen displays with:
   - Original image with bounding boxes
   - Total chip count
   - Count by color
   - Processing time

### Detection Results

- Each detected chip has a colored bounding box
- Colors match chip types:
  - ⚫ Black chips → White box
  - 🟢 Green chips → Green box
  - 🔴 Red chips → Red box
  - ⚪ White-Blue chips → Blue box

## 🔧 Troubleshooting

### Model Not Loading

**Error:** "Model file not found"

**Solution:**

1. Verify `best.mlpackage` is in the project
2. Check it's added to the app target
3. Clean build folder: `Product → Clean Build Folder`
4. Rebuild the project

### Camera Not Working

**Error:** Camera doesn't open

**Solution:**

1. Check Info.plist has camera permission description
2. Reset simulator: `Device → Erase All Content and Settings`
3. On real device, check Settings → Privacy → Camera

### Poor Detection Results

**Problem:** Chips not detected or wrong colors

**Solution:**

1. Ensure good lighting
2. Take photo from top-down angle
3. Keep chips spread out (not overlapping)
4. Adjust confidence threshold in `ChipDetectionViewModel`:
   ```swift
   var confidenceThreshold: Float = 0.3  // Lower = more detections
   ```

### Build Errors

**Error:** "Cannot find type 'ChipDetection' in scope"

**Solution:**

1. Verify all Swift files are added to the target
2. Check file names match exactly
3. Clean build folder and rebuild

## ⚙️ Configuration Options

### Adjust Confidence Threshold

In `ChipDetectionViewModel.swift`:

```swift
// Lower threshold = more detections (may include false positives)
var confidenceThreshold: Float = 0.3

// Higher threshold = fewer detections (more accurate)
var confidenceThreshold: Float = 0.7
```

### Change Image Size

In `ChipDetectionViewModel.swift`, the model expects 640x640 images by default. This is handled automatically.

### Performance Optimization

For better performance on older devices:

1. In `ChipDetectionViewModel.swift`:

```swift
config.computeUnits = .cpuOnly  // Use CPU only
// or
config.computeUnits = .cpuAndGPU  // Use CPU and GPU
// or
config.computeUnits = .all  // Use Neural Engine (best, default)
```

## 📊 Testing Recommendations

### Test with Different Scenarios

1. **Lighting:**

   - Bright daylight
   - Indoor lighting
   - Low light

2. **Angles:**

   - Top-down (best)
   - 45-degree angle
   - Side view

3. **Chip Arrangements:**

   - Scattered chips
   - Stacked chips
   - Mixed colors
   - Single color

4. **Distances:**
   - Close-up
   - Medium distance
   - Far away

### Test Images

Use the validation images in `data/valid/images/` for testing:

- Add them to your iOS photo library
- Test with "Choose from Library" option

## 📁 Project Structure

```
readmyobject/
├── readmyobject/
│   ├── Models/
│   │   └── ChipDetection.swift
│   ├── ViewModels/
│   │   └── ChipDetectionViewModel.swift
│   ├── Views/
│   │   ├── CameraView.swift
│   │   └── DetectionResultView.swift
│   ├── ContentView.swift
│   ├── readmyobjectApp.swift
│   ├── Info.plist
│   └── Assets.xcassets/
├── customModel/
│   ├── best.pt                 # Original PyTorch model
│   ├── best.onnx              # ONNX model
│   └── best.mlpackage         # Core ML model (iOS)
└── convert_to_coreml.py       # Conversion script
```

## 🎯 Features Implemented

- ✅ Camera capture with back camera
- ✅ Photo library integration
- ✅ Real-time chip detection
- ✅ Bounding box visualization
- ✅ Color-coded detection boxes
- ✅ Total chip count
- ✅ Count by color
- ✅ Confidence scores
- ✅ Processing time display
- ✅ Error handling
- ✅ Loading indicators

## 🔮 Future Enhancements

Potential additions:

- [ ] Real-time video detection
- [ ] Manual threshold adjustment slider
- [ ] Save results to photo library
- [ ] Export results as CSV/JSON
- [ ] Chip value calculation
- [ ] History of detections
- [ ] Dark mode support
- [ ] iPad optimization
- [ ] Landscape orientation support

## 📞 Support

If you encounter issues:

1. Check this guide first
2. Review error messages in Xcode console
3. Verify all setup steps completed
4. Check [MODEL_INFO.md](MODEL_INFO.md) for model details
5. Submit issues via GitHub

## 📝 Notes

- **First Run:** Allow camera and photo permissions
- **Simulator:** Camera won't work on simulator, use photo library
- **Real Device:** Recommended for best experience
- **iOS Version:** Requires iOS 15.0 or later
- **Model Updates:** To update model, reconvert and replace .mlpackage

---

**Ready to detect chips!** 🎰

_Last Updated: December 24, 2025_
