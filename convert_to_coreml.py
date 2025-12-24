#!/usr/bin/env python3
"""
Convert YOLOv8 model to Core ML format for iOS deployment
"""

from ultralytics import YOLO
import os


def convert_model():
    model_path = 'customModel/best.pt'

    if not os.path.exists(model_path):
        print(f"Error: Model file not found at {model_path}")
        return

    print(f"Loading model from {model_path}...")
    model = YOLO(model_path)

    print("Converting to Core ML format...")
    print("This may take a few minutes...")

    # Export to Core ML with NMS (Non-Maximum Suppression) included
    model.export(
        format='coreml',
        nms=True,
        imgsz=640,
        int8=False,  # Set to True for smaller model size (quantization)
    )

    print("\n✅ Conversion complete!")
    print(f"Core ML model saved as: customModel/best.mlpackage")
    print("\nNext steps:")
    print("1. Drag and drop the 'best.mlpackage' file into your Xcode project")
    print("2. Make sure it's added to your app target")
    print("3. The model will be automatically available in your Swift code")


if __name__ == "__main__":
    try:
        convert_model()
    except Exception as e:
        print(f"\n❌ Error during conversion: {e}")
        print("\nTroubleshooting:")
        print("- Make sure ultralytics is installed: pip install ultralytics")
        print("- Make sure coremltools is installed: pip install coremltools")
        print("- Check that customModel/best.pt exists")
