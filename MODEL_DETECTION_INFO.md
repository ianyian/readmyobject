# Object Detection Model Information

## ⚠️ Important: Current Model Limitation

Your current model **`best.mlpackage`** (converted from `best.pt`) is a **custom-trained YOLOv8 model** that was trained ONLY for **poker chip detection** (4 classes):

- Class 0: Black chips
- Class 1: Green chips
- Class 2: Red chips
- Class 3: White-Blue chips

### This means:

- ✅ **Will detect**: Poker chips in these 4 colors
- ❌ **Will NOT detect**: People, dogs, cars, bicycles, or any other objects

## 🔍 Debugging Your Detections

I've added debug logging to help diagnose issues. When you run detection, check the Xcode console for:

```
🔍 Processing X observations
📊 Detected: 'label' with confidence 0.XX
✅ Accepted: 'label'
🎯 Created detection: label='Label', box=...
📈 Total detections created: X
✨ Detection complete - showing X objects
```

If you see:

- `Processing 0 observations` → Model didn't detect anything at all
- Detections but filtered out → Mode filter is removing valid detections
- Detections created but count is 0 → Check the results page logic

## 🎯 Solutions to Detect General Objects

### Option 1: Use Standard YOLOv8 Model (Recommended)

Download a pre-trained COCO YOLOv8 model that can detect 80 object classes:

```bash
# Download standard YOLOv8 model
pip install ultralytics
python3 << 'EOF'
from ultralytics import YOLO

# Load pre-trained YOLOv8 model
model = YOLO('yolov8n.pt')  # or yolov8s.pt, yolov8m.pt, yolov8l.pt, yolov8x.pt

# Export to CoreML
model.export(format='coreml', nms=True, imgsz=640)
print("✅ Exported yolov8n.mlpackage")
EOF

# Replace your model
mv yolov8n.mlpackage customModel/best.mlpackage
```

### Option 2: Train Your Own Model

If you want to detect specific objects, train a custom YOLOv8 model:

```bash
from ultralytics import YOLO

# Create a dataset with your objects
# Train custom model
model = YOLO('yolov8n.pt')
results = model.train(data='your-dataset.yaml', epochs=100)

# Export to CoreML
model.export(format='coreml')
```

### Option 3: Use Multiple Models

Update the code to load different models based on detection mode:

- Poker Chips mode → Load `best.mlpackage` (chip model)
- Other modes → Load `yolov8_coco.mlpackage` (general objects)

## 📋 Standard YOLOv8 COCO Classes (80 objects)

The standard model can detect:

- **People**: person
- **Vehicles**: bicycle, car, motorcycle, airplane, bus, train, truck, boat
- **Animals**: bird, cat, dog, horse, sheep, cow, elephant, bear, zebra, giraffe
- **Objects**: bottle, chair, couch, bed, dining table, laptop, cell phone, book, etc.

## 🔧 Quick Test

To verify what your model detects:

1. Set mode to "All Objects"
2. Take a photo of various objects
3. Check the Xcode console logs
4. You'll see what labels the model actually returns

If you only see classes 0-3, that confirms it's the custom chip model.
If you see "person", "dog", "car", etc., you have a general model.

## 📝 Code Updates Made

I've added:

- ✅ Debug logging throughout detection pipeline
- ✅ COCO class ID mapping (0-79 → readable names)
- ✅ Better handling of numeric class IDs
- ✅ Improved filtering logic

This will help diagnose why detections aren't showing up!
