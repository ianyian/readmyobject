# Quick Start Guide - Poker Chip Detector iOS App

## ⚡ 5-Minute Setup

### 1️⃣ Convert Model (2 minutes)

```bash
cd /Users/xj/git/readmyobject
pip install ultralytics coremltools
python convert_to_coreml.py
```

Wait for: `✅ Conversion complete!`

### 2️⃣ Open Xcode (1 minute)

```bash
open readmyobject.xcodeproj
```

### 3️⃣ Add Model to Xcode (1 minute)

Drag `customModel/best.mlpackage` into Xcode project navigator

- ✅ Copy items if needed
- ✅ readmyobject target selected

### 4️⃣ Add Swift Files (1 minute)

Create folders in Xcode and add files:

**Models/** → Add:

- `readmyobject/Models/ChipDetection.swift`

**ViewModels/** → Add:

- `readmyobject/ViewModels/ChipDetectionViewModel.swift`

**Views/** → Add:

- `readmyobject/Views/CameraView.swift`
- `readmyobject/Views/DetectionResultView.swift`

**Replace:**

- `readmyobject/ContentView.swift` (already updated)

**Add to project root:**

- `readmyobject/Info.plist`

### 5️⃣ Build & Run (30 seconds)

Press `Cmd + R` or click ▶️

## ✅ That's It!

The app will:

1. Ask for camera permission → Grant it
2. Show main screen with "Take Photo" button
3. Capture photo → Automatically detect chips
4. Display results with counts by color

## 📋 File Checklist

Make sure these files are in your Xcode project:

```
readmyobject (target)
├── Models/
│   └── ChipDetection.swift ✓
├── ViewModels/
│   └── ChipDetectionViewModel.swift ✓
├── Views/
│   ├── CameraView.swift ✓
│   └── DetectionResultView.swift ✓
├── ContentView.swift ✓
├── readmyobjectApp.swift ✓
├── Info.plist ✓
└── best.mlpackage ✓ (in project root or Models folder)
```

## 🎯 Quick Test

1. Run app on device or simulator
2. Grant camera permission
3. Tap "Choose from Library"
4. Select a photo from `data/valid/images/`
5. See detection results!

## 🐛 Quick Fixes

**Model not found?**
→ Drag `best.mlpackage` into Xcode again, ensure target is checked

**Build errors?**
→ Product → Clean Build Folder → Rebuild

**Camera not working on simulator?**
→ Use "Choose from Library" instead

---

For detailed setup, see [IOS_SETUP_GUIDE.md](IOS_SETUP_GUIDE.md)
