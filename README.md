# Read My Chips 🎰

A custom YOLOv8-based poker chip detection and counting system for real-time chip recognition and inventory management.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.8%2B-blue.svg)
![YOLOv8](https://img.shields.io/badge/YOLOv8-Ultralytics-00FFFF.svg)

## 🎯 Overview

This project implements a computer vision solution to detect and count poker chips by color using a custom-trained YOLOv8 model. Perfect for:

- 🎲 Poker game assistance
- 📊 Chip inventory management
- 💰 Stack valuation
- 📱 Mobile app integration (iOS/Android)

## � Website & Documentation

**Live Website:** https://ianyian.github.io/readmyobject/

- 📄 [Privacy Policy](https://ianyian.github.io/readmyobject/privacy-policy.html)
- 💡 [Support & Help](https://ianyian.github.io/readmyobject/support.html)
- 📱 [Download on App Store](#) *(coming soon)*

## �🎨 Detected Chip Colors

| Color         | Description                   |
| ------------- | ----------------------------- |
| ⚫ Black      | Standard black poker chips    |
| 🟢 Green      | Standard green poker chips    |
| 🔴 Red        | Standard red poker chips      |
| ⚪ White-Blue | White chips with blue accents |

## 🚀 Quick Start

### Prerequisites

- Python 3.8 or higher
- pip package manager
- (Optional) GPU with CUDA for faster training

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/ianyian/read-my-chips.git
cd read-my-chips
```

2. **Create virtual environment**

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**

```bash
pip install -r requirements.txt
```

Or manually install:

```bash
pip install ultralytics opencv-python matplotlib pillow torch torchvision
```

### Usage

#### Test the Model

Run the detection script on validation images:

```bash
# Test with 3 random images (default)
python test_detection.py

# Test with 5 random images
python test_detection.py --num 5

# Test a specific image
python test_detection.py --specific IMG_3056.jpg

# Use training images
python test_detection.py --images data/train/images

# Adjust confidence threshold
python test_detection.py --conf 0.3

# No display (results only)
python test_detection.py --no-display
```

#### Command-Line Options

```bash
Options:
  --model PATH       Path to trained model (default: customModel/best.pt)
  --images PATH      Path to images folder (default: data/valid/images)
  --conf FLOAT       Confidence threshold 0-1 (default: 0.5)
  --num INT          Number of random images to test (default: 3)
  --specific NAME    Test specific image by filename
  --no-display       Print results without showing images
```

## 📁 Project Structure

```
read-my-chips/
├── customModel/
│   ├── best.pt              # Trained PyTorch model
│   └── best.onnx            # ONNX model for deployment
├── data/
│   ├── train/               # Training images and labels
│   ├── valid/               # Validation images and labels
│   └── data.yaml            # Dataset configuration
├── notebooks/
│   ├── My_Train_YOLO_Models.ipynb          # Main training notebook
│   ├── Test_Poker_Chip_Detection.ipynb    # Testing notebook
│   └── Train_YOLOv8_Custom.ipynb          # Alternative training
├── test_detection.py        # Standalone detection script
├── MODEL_INFO.md           # Detailed model documentation
├── COLAB_SETUP.md          # Google Colab setup guide
├── DEPLOYMENT_GUIDE.md     # Deployment instructions
└── README.md               # This file
```

## 📊 Model Performance

- **Architecture:** YOLOv8 (Ultralytics)
- **Input Size:** 640×640 pixels
- **Classes:** 4 (Black, Green, Red, White-Blue)
- **Inference Speed:** 20-60 FPS on modern hardware
- **Format:** PyTorch (.pt), ONNX (.onnx), Core ML (exportable)

## 📱 Mobile App Integration

This model is designed for mobile deployment! See [MODEL_INFO.md](MODEL_INFO.md) for detailed iOS integration guide including:

- ✅ Core ML conversion instructions
- ✅ ONNX Runtime setup
- ✅ Input/output format specifications
- ✅ Swift code examples
- ✅ Performance optimization tips
- ✅ UI/UX recommendations

### Export for iOS

```python
from ultralytics import YOLO

model = YOLO('customModel/best.pt')

# Export to Core ML for iOS
model.export(format='coreml', nms=True, imgsz=640)

# Export to ONNX (alternative)
model.export(format='onnx', simplify=True, imgsz=640)
```

## 🎓 Training Your Own Model

### Using Jupyter Notebooks

1. Open `My_Train_YOLO_Models.ipynb` in Jupyter or VS Code
2. Follow the step-by-step instructions
3. Adjust hyperparameters as needed
4. Train on your custom dataset

### Using Google Colab

1. See [COLAB_SETUP.md](COLAB_SETUP.md) for detailed instructions
2. Upload your dataset or use Roboflow integration
3. Train with free GPU access

### Dataset Format

Uses YOLO format:

```
data/
├── train/
│   ├── images/
│   │   ├── img1.jpg
│   │   └── img2.jpg
│   └── labels/
│       ├── img1.txt
│       └── img2.txt
└── valid/
    ├── images/
    └── labels/
```

Label format (one line per object):

```
<class_id> <x_center> <y_center> <width> <height>
```

## 🔧 Customization

### Adjust Confidence Threshold

```python
# Lower threshold = more detections (less strict)
results = model(image, conf=0.3)

# Higher threshold = fewer detections (more strict)
results = model(image, conf=0.7)
```

### Add New Chip Colors

1. Collect and label new training images
2. Update `data/data.yaml` with new classes
3. Retrain the model with updated dataset

## 📈 Results Visualization

The detection script provides:

- ✅ Bounding boxes around detected chips
- ✅ Class labels with confidence scores
- ✅ Total chip count
- ✅ Count by color
- ✅ Summary statistics

Example output:

```
============================================================
Testing: IMG_3056.jpg
============================================================

Total poker chips detected: 12

  • Black poker chips: 3
  • Green poker chips: 4
  • Red poker chips: 3
  • White-blue poker chips: 2

============================================================
```

## 🛠️ Requirements

### Python Dependencies

```
ultralytics>=8.0.0
opencv-python>=4.6.0
torch>=1.8.0
torchvision>=0.9.0
matplotlib>=3.3.0
pillow>=8.0.0
numpy>=1.23.0
pyyaml>=5.3.1
```

### Hardware Recommendations

**Training:**

- GPU: NVIDIA GPU with 8GB+ VRAM (recommended)
- RAM: 16GB+ system memory
- Storage: 10GB+ free space

**Inference:**

- CPU: Any modern processor
- RAM: 4GB+ system memory
- GPU: Optional, improves speed

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Ultralytics YOLOv8](https://github.com/ultralytics/ultralytics) - Object detection framework
- [Roboflow](https://roboflow.com/) - Dataset management and augmentation
- Community contributors and testers

## 📞 Contact & Support

- **Repository:** [https://github.com/ianyian/read-my-chips](https://github.com/ianyian/read-my-chips)
- **Issues:** Submit via [GitHub Issues](https://github.com/ianyian/read-my-chips/issues)
- **Discussions:** Use [GitHub Discussions](https://github.com/ianyian/read-my-chips/discussions)

## 🗺️ Roadmap

- [ ] Add more chip colors and denominations
- [ ] Implement chip value calculation
- [ ] Android app integration guide
- [ ] Web-based demo
- [ ] Docker containerization
- [ ] REST API for cloud deployment
- [ ] Real-time video stream processing
- [ ] Multi-camera support

---

**Made with ❤️ for the poker community**

_Last updated: December 24, 2025_
