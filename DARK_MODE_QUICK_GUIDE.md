# Dark Mode - Quick Reference

## 🚀 Quick Access

**To change appearance:**

1. Tap ⚙️ (Settings) in top-right
2. Select your preferred theme:
   - 🌞 **Light** - Always bright
   - 🌙 **Dark** - Always dark
   - 🔄 **System** - Match iOS (default)
3. Done! Changes apply instantly

## 🎨 What's Different?

### Light Mode

```
┌─────────────────────────┐
│  ⚪ Poker Chip Detector  │ ← Bright backgrounds
│                         │
│  📸 Take Photo          │ ← High contrast
│  📷 Choose Library      │
│                         │
│  Detection results      │ ← Clear and crisp
└─────────────────────────┘
```

### Dark Mode

```
┌─────────────────────────┐
│  ⚫ Poker Chip Detector  │ ← Dark backgrounds
│                         │
│  📸 Take Photo          │ ← Reduced eye strain
│  📷 Choose Library      │
│                         │
│  Detection results      │ ← Easy on eyes
└─────────────────────────┘
```

## ✅ Always Bright

These elements stay bright in **both** themes for visibility:

- ✅ Bounding boxes on photos
- ✅ Chip detection labels
- ✅ Confidence percentages
- ✅ Camera preview

## 💡 Tips

**Best for Day:** Light or System  
**Best for Night:** Dark or System  
**Best for Battery:** Dark (on OLED)  
**Best Overall:** System (automatic)

## 🔄 File Summary

New files for dark mode:

- `ColorExtensions.swift` - Color definitions
- `AppearanceSettingsView.swift` - Settings UI

Updated files:

- `ChipDetection.swift` - Adaptive colors
- `ContentView.swift` - Settings integration
- `DetectionResultView.swift` - Dark mode support

---

For complete details, see [DARK_MODE_GUIDE.md](DARK_MODE_GUIDE.md)
