#!/usr/bin/env python3
"""
Generate a simple app icon for Object Detector
Creates a 1024x1024 icon with a poker chip/detection theme
"""

import os

try:
    from PIL import Image, ImageDraw, ImageFont

    def create_app_icon():
        # Create 1024x1024 image
        size = 1024
        icon = Image.new('RGB', (size, size), color='#007AFF')
        draw = ImageDraw.Draw(icon)

        # Draw background gradient effect (simple circles)
        center = size // 2

        # Main circle (poker chip style)
        circle_radius = 380
        draw.ellipse(
            [center - circle_radius, center - circle_radius,
             center + circle_radius, center + circle_radius],
            fill='white'
        )

        # Inner circle
        inner_radius = 320
        draw.ellipse(
            [center - inner_radius, center - inner_radius,
             center + inner_radius, center + inner_radius],
            fill='#007AFF'
        )

        # Draw grid pattern (3x3) for "detection" theme
        grid_size = 180
        grid_start = center - grid_size
        grid_thickness = 20

        for i in range(4):
            # Vertical lines
            x = grid_start + i * (grid_size * 2 // 3)
            draw.rectangle(
                [x - grid_thickness//2, grid_start,
                 x + grid_thickness//2, grid_start + grid_size * 2],
                fill='white'
            )
            # Horizontal lines
            y = grid_start + i * (grid_size * 2 // 3)
            draw.rectangle(
                [grid_start, y - grid_thickness//2,
                 grid_start + grid_size * 2, y + grid_thickness//2],
                fill='white'
            )

        # Save the icon
        output_path = 'app-icon-1024.png'
        icon.save(output_path, 'PNG')
        print(f"✅ Icon created: {output_path}")
        print(f"📱 Size: 1024x1024 pixels")
        print("\nNext steps:")
        print("1. Use https://www.appicon.co/ to generate all sizes")
        print("2. Upload app-icon-1024.png")
        print("3. Download the AppIcon.appiconset folder")
        print("4. Add to Xcode Assets.xcassets")

        return output_path

    if __name__ == "__main__":
        create_app_icon()

except ImportError:
    print("⚠️  Pillow not installed. Installing...")
    print("\nRun: pip3 install Pillow")
    print("\nOr use the quick emoji method from CREATE_APP_ICON.md")
    print("\nAlternatively, visit https://www.appicon.co/ and upload any 1024x1024 image")
