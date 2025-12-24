# Changelog

All notable changes to Poker Chip Counter will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-24

### 🎉 Initial Release

#### Added

- **Custom Poker Chip Detection**

  - YOLOv8-based ML model trained on 4 poker chip colors
  - 95% detection accuracy with proper setup
  - On-device Core ML processing for privacy

- **Multiple Detection Modes**

  - Poker Chips (custom trained model)
  - All Objects (general purpose detection)
  - Person, Car, Dog, Cat detection modes
  - Bicycle, Motorcycle, Bird, Horse detection modes
  - Easy mode switching in settings

- **Photo Detection**

  - Analyze existing photos from library
  - Bounding box visualization
  - Confidence scores displayed
  - Total object count
  - Support for all detection modes

- **Live Stream Detection**

  - Real-time camera feed processing
  - Adjustable refresh rate (0.1 - 2.0 seconds)
  - Tap-to-pause/resume functionality
  - Mode indicator overlay
  - Continuous detection while active

- **Detection History Charts**

  - Stacked bar chart showing detection over time
  - Color-coded by object type
  - Scrollable history (last 30 entries)
  - Auto-scroll to latest data
  - Pauses when detection is paused

- **CPU Usage Monitoring**

  - Real-time CPU usage tracking
  - Clean green line chart
  - Dynamic Y-axis scaling (adjusts to actual usage)
  - Continues monitoring even when paused
  - Performance optimization indicators

- **Customizable Settings**

  - Minimum confidence threshold (10% - 95%)
  - Live detection refresh rate control
  - Detection mode selection
  - Appearance theme (Light/Dark/System)
  - Settings persist across app launches

- **User Interface**

  - Clean, modern SwiftUI interface
  - Dark mode support
  - Intuitive navigation
  - Professional chart visualizations
  - Smooth animations and transitions

- **Privacy & Security**
  - 100% on-device processing
  - No data collection or transmission
  - No user accounts required
  - Camera data never stored
  - Photos never uploaded
  - Complete privacy guaranteed

#### Technical Details

- Minimum iOS version: 15.0
- Supported devices: iPhone, iPad
- App size: ~54 MB (includes ML models)
- Technologies: SwiftUI, Core ML, Vision, AVFoundation
- ML Models: YOLOv8 (custom + standard)

#### Known Limitations

- Detection history not persisted (clears on app restart)
- No export functionality for results
- English language only
- Portrait orientation only

### Notes

This is the initial public release. We welcome your feedback and feature requests!

---

## [Unreleased] - Future Plans

### Planned Features for v1.1

- Export detection results (CSV, JSON formats)
- Detection history persistence
- Save and load detection sessions
- Improved iPad interface
- Landscape orientation support

### Planned Features for v1.2

- Multiple language support (Spanish, Chinese, French, German)
- Advanced analytics and statistics
- Detection result sharing
- Custom model training interface
- Apple Watch companion app

### Planned Features for v2.0

- Cloud sync (optional)
- Multi-device detection
- Batch photo processing
- Advanced filtering options
- AR overlay mode

---

## Version History

| Version | Release Date | Status      |
| ------- | ------------ | ----------- |
| 1.0.0   | 2025-12-24   | Released ✅ |

---

_For support, visit: [SUPPORT.md](SUPPORT.md)_  
_For privacy information, visit: [PRIVACY_POLICY.md](PRIVACY_POLICY.md)_
