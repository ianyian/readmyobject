# Object Detector Pro Max - Support & Help

Welcome to Object Detector Pro Max support! This guide will help you get the most out of the app.

## 📱 Quick Start Guide

### First Launch

1. Open the app
2. Grant camera permission when prompted (required for live detection)
3. Grant photo library permission when prompted (optional, for photo detection)
4. You'll see three main options on the home screen

### Main Features

#### 🖼️ Take Photo to Detect

**What it does:** Analyze existing photos from your library

**How to use:**

1. Tap "Take Photo to Detect" button
2. Select a photo from your library
3. Wait for detection to complete
4. View detected objects with bounding boxes
5. See confidence scores and labels
6. Total count displayed at top

**Tips:**

- Use clear, well-lit photos
- Objects should be clearly visible
- Works best with photos of poker chips
- Try different photos if detection isn't accurate

#### 🎥 Live Detection

**What it does:** Real-time object detection using your camera

**How to use:**

1. Tap "Live Detection" button
2. Point camera at objects (poker chips recommended)
3. Watch real-time detection and counting
4. **Tap screen to pause** - inspect frozen frame
5. **Tap again to resume** detection
6. View detection history chart (bottom section)
7. Monitor CPU usage (below history chart)

**Tips:**

- Hold device steady for best results
- Ensure good lighting
- Keep objects in frame
- Tap to pause when you need to verify count
- Charts update in real-time showing detection trends

#### ⚙️ Settings

**What it does:** Customize app behavior

**How to access:**

1. Tap gear icon in top-right corner
2. Adjust settings as needed
3. Tap "Done" to save

### Settings Explained

#### Detection Mode

Choose what type of objects to detect:

- **All Objects** - Detect everything the model can recognize
- **Poker Chips** - Custom model for accurate chip detection ⭐
- **Person** - Detect people only
- **Car** - Detect cars only
- **Dog, Cat, Bicycle, Motorcycle, Bird, Horse** - Specialized modes

**Tip:** For poker chip counting, always use "Poker Chips" mode

#### Minimum Confidence (Confidence Threshold)

Controls detection accuracy:

- **95% (Recommended for Poker Chips)** ⭐

  - Very strict, only counts obvious chips
  - Minimizes false positives
  - Best for accurate counting

- **80-90%**

  - Moderate strictness
  - May include some false positives
  - Good for general object detection

- **50-70%**
  - Lenient, detects more objects
  - May count non-chips as chips
  - Use only if you're missing real objects

**How it works:**

- Slider value is the minimum confidence required
- 95% = Model must be ≥95% confident to count object
- Lower value = More detections (including false positives)
- Higher value = Fewer detections (only confident ones)

**Troubleshooting:**

- **Too many false detections?** → Increase to 95%
- **Missing real chips?** → Decrease to 85-90%

#### Live Detection Refresh Rate

Controls how often live detection updates:

- **Fast (0.1s)** - Very responsive, higher CPU usage
- **Default (0.5s)** - Balanced performance ⭐
- **Slow (2.0s)** - Lower CPU usage, less responsive

#### Appearance Theme

- **System** - Follow device theme (recommended)
- **Light** - Always use light mode
- **Dark** - Always use dark mode

## 🎯 Best Practices

### For Accurate Poker Chip Counting

1. **Use Poker Chips Mode** ✅

   - Settings → Detection Mode → Poker Chips

2. **Set Confidence to 95%** ✅

   - Settings → Minimum Confidence → Slide to 95%

3. **Good Lighting** ✅

   - Ensure chips are well-lit
   - Avoid shadows and glare
   - Natural lighting works best

4. **Clear View** ✅

   - Keep chips visible in frame
   - Don't overlap chips too much
   - Hold camera steady

5. **Use Live Detection** ✅
   - More accurate than photo detection
   - Can adjust angle in real-time
   - Tap to pause and verify count

### For Best Performance

1. **Close other apps** - Free up device resources
2. **Keep app updated** - Install updates when available
3. **Restart app if slow** - Fresh start can help
4. **Use moderate refresh rate** - 0.5s default is optimal

## 🐛 Troubleshooting

### App Won't Open Camera

**Solution:**

1. Go to iPhone Settings
2. Scroll to "Object Detector Pro Max"
3. Tap "Camera"
4. Select "Allow"
5. Restart app

### Can't Select Photos

**Solution:**

1. Go to iPhone Settings
2. Scroll to "Object Detector Pro Max"
3. Tap "Photos"
4. Select "All Photos" or "Selected Photos"
5. Restart app

### Detection Not Working

**Check:**

- ✓ Camera permission granted
- ✓ Objects clearly visible
- ✓ Good lighting
- ✓ Correct detection mode selected
- ✓ Confidence threshold not too high (try 85-90%)

### Too Many False Detections

**Solution:**

1. Open Settings
2. Increase "Minimum Confidence" to 95%
3. Ensure "Poker Chips" mode is selected
4. Improve lighting conditions

### Missing Real Chips

**Solution:**

1. Decrease confidence to 85-90%
2. Improve lighting
3. Adjust camera angle
4. Try different distances

### App Crashing or Freezing

**Solution:**

1. Force quit app: Swipe up from bottom, swipe app away
2. Restart iPhone
3. Update to latest iOS version
4. Reinstall app (will not lose settings)

### Charts Not Updating (Live Detection)

**Solution:**

- This is normal when paused - tap screen to resume
- If frozen when not paused, restart app
- Check refresh rate setting

### High Battery Drain

**Solution:**

1. Increase refresh rate (Settings → Live Detection → 1.0s or higher)
2. Close app when not in use
3. Use photo detection instead of live detection when possible

## ❓ Frequently Asked Questions

### Does the app store my photos?

**No.** All photos stay on your device. Nothing is uploaded or stored.

### Does it work offline?

**Yes.** All processing happens on your device. No internet required.

### What phones are supported?

iPhone running iOS 15.0 or later. iPad is also supported.

### Can I export detection results?

Not in version 1.0. This feature is planned for future updates.

### Why are some chips not detected?

- Confidence threshold too high (lower it in settings)
- Poor lighting
- Chips too far from camera
- Chips partially obscured

### Can it count other objects?

Yes! Change detection mode in settings. Works with 10 different object types.

### How accurate is the counting?

With proper setup (95% confidence, good lighting, Poker Chips mode), accuracy is typically 95%+.

## 📊 Understanding the Live Detection Charts

### Detection History (Stacked Bars)

- Each bar = one detection snapshot
- Different colors = different object types
- Height = number of objects detected
- Scrolls right to left (newest on right)
- Stops updating when paused

### CPU Usage (Green Line)

- Shows app's CPU usage
- Updates every 0.5 seconds
- Continues even when paused
- Dynamic Y-axis adjusts to usage level
- Lower is better

## 📧 Contact Support

### Report a Bug

Email: [your-support-email@example.com]
Include:

- iPhone model
- iOS version
- Description of issue
- Screenshots if possible

### Feature Request

Email: [your-support-email@example.com]
Subject: "Feature Request"
Tell us what you'd like to see!

### General Questions

- Email: [your-support-email@example.com]
- GitHub: https://github.com/ianyian/readmyobject
- Response time: Usually within 48 hours

## 🔄 App Updates

**Version 1.0.0** (Current)

- Initial release
- Poker chip detection
- 10 detection modes
- Live detection with charts
- Tap-to-pause functionality

**Planned Updates:**

- Export detection results
- Detection history persistence
- More languages
- iPad optimization
- Apple Watch companion

## 🎓 Tips & Tricks

### Pro Tips for Poker Players

1. **Pre-game Setup**

   - Calibrate: Test with your actual chips
   - Adjust confidence until count is accurate
   - Save settings for next time

2. **During Game**

   - Use live detection for quick counts
   - Tap to pause when count looks right
   - Take a photo if you need a record

3. **Stack Valuation**
   - Count each color separately
   - Use photo detection for permanent record
   - Double-check with manual count first time

### Hidden Features

- **Double-tap anywhere**: Quick access to settings
- **Long press mode indicator**: Copy current settings
- **Swipe charts**: Scroll through detection history

## 📱 System Requirements

- **iOS**: 15.0 or later
- **Storage**: 60 MB free space
- **Camera**: Rear camera recommended
- **RAM**: 2GB+ recommended

## 🔐 Privacy & Security

- No data collection
- All processing on-device
- No internet connection needed
- Camera data never stored
- Photos never uploaded
- Complete privacy guaranteed

See full [Privacy Policy](PRIVACY_POLICY.md)

## 💡 Need More Help?

Can't find your answer? Contact us:

📧 **Email**: [your-support-email@example.com]  
🐙 **GitHub**: https://github.com/ianyian/readmyobject  
⭐ **Rate the App**: Help others find us!

---

**Object Detector Pro Max** - AI-Powered Object Detection

_Version 1.0.0 | Last Updated: December 24, 2025_
