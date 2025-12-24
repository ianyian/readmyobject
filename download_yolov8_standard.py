#!/usr/bin/env python3
"""
Download and convert standard YOLOv8 COCO model to Core ML format
This model can detect 80 different object classes including people, animals, vehicles, etc.
"""

import sys
import os

try:
    from ultralytics import YOLO
    print("✅ ultralytics package found")
except ImportError:
    print("❌ ultralytics not installed. Installing...")
    os.system(f"{sys.executable} -m pip install ultralytics")
    from ultralytics import YOLO


def download_and_convert():
    print("\n🚀 Downloading YOLOv8n (nano) model - smallest and fastest...")
    print("   (You can also use yolov8s, yolov8m, yolov8l, or yolov8x for higher accuracy)\n")

    # Load pre-trained YOLOv8n model (trained on COCO dataset - 80 classes)
    model = YOLO('yolov8n.pt')

    print("\n📦 Model downloaded. Classes it can detect:")
    print("   People, vehicles (car, bicycle, bus, truck, motorcycle, airplane, train, boat)")
    print("   Animals (dog, cat, bird, horse, sheep, cow, elephant, bear, zebra, giraffe)")
    print("   Objects (bottle, chair, couch, laptop, phone, book, etc.)")
    print("   Total: 80 COCO dataset classes\n")

    print("🔄 Converting to Core ML format...")
    print("   This may take 2-3 minutes...\n")

    # Export to CoreML format
    # nms=True includes Non-Maximum Suppression in the model
    # imgsz=640 sets input image size
    success = model.export(
        format='coreml',
        nms=True,
        imgsz=640
    )

    print(f"\n✅ Conversion complete!")
    print(f"📁 Model saved as: yolov8n.mlpackage")

    # Move to customModel directory
    import shutil
    target_dir = "customModel"
    target_path = os.path.join(target_dir, "yolov8n.mlpackage")

    if os.path.exists("yolov8n.mlpackage"):
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)

        if os.path.exists(target_path):
            print(f"\n🗑️  Removing existing {target_path}")
            shutil.rmtree(target_path)

        print(f"📦 Moving to {target_path}")
        shutil.move("yolov8n.mlpackage", target_path)

        print("\n✅ SUCCESS! Standard YOLOv8 model ready!")
        print(f"📍 Location: {target_path}")
        print("\n📝 Your project now has TWO models:")
        print("   1. best.mlpackage - Custom poker chip detector (4 classes)")
        print("   2. yolov8n.mlpackage - Standard objects detector (80 classes)")
        print("\n🎯 The app will automatically switch between them based on detection mode!")

        # Get file size
        size_mb = os.path.getsize(target_path) / (1024 * 1024)
        print(f"📊 Model size: {size_mb:.1f} MB")

    else:
        print("❌ Error: Model file not found after export")
        return False

    return True


if __name__ == "__main__":
    print("=" * 70)
    print("   YOLOv8 Standard COCO Model Downloader")
    print("=" * 70)

    try:
        success = download_and_convert()
        if success:
            print("\n" + "=" * 70)
            print("   ✅ ALL DONE! Rebuild your iOS app in Xcode.")
            print("=" * 70)
            sys.exit(0)
        else:
            sys.exit(1)
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
