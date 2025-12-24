//
//  AppearanceSettingsView.swift
//  readmyobject
//
//  Created by XJ on 24/12/2025.
//

import SwiftUI

/// View for managing app appearance settings including dark mode
struct AppearanceSettingsView: View {
    @AppStorage("appAppearance") private var appAppearance: AppearanceMode = .system
    @AppStorage("showConfidence") private var showConfidence: Bool = false
    @AppStorage("detectionSensitivity") private var detectionSensitivity: Double = 0.95
    @AppStorage("liveDetectionRefreshRate") private var liveRefreshRate: Double = 0.5
    @AppStorage("detectionMode") private var detectionModeRaw: String = DetectionMode.allObjects.rawValue
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Mode", selection: $detectionModeRaw) {
                        ForEach(DetectionMode.allCases) { mode in
                            HStack {
                                Image(systemName: mode.icon)
                                Text(mode.displayName)
                            }
                            .tag(mode.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    if let currentMode = DetectionMode(rawValue: detectionModeRaw) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: currentMode.icon)
                                    .foregroundColor(.blue)
                                Text(currentMode.displayName)
                                    .font(.body.weight(.semibold))
                            }
                            
                            Text(currentMode.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, 8)
                    }
                } header: {
                    Text("Detection Mode")
                } footer: {
                    Text("Select which objects to detect. 'All Objects' detects everything the model was trained on.")
                }
                
                Section {
                    ForEach(AppearanceMode.allCases, id: \.self) { mode in
                        Button(action: {
                            appAppearance = mode
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(mode.displayName)
                                        .foregroundColor(.primary)
                                        .font(.body.weight(appAppearance == mode ? .semibold : .regular))
                                    
                                    Text(mode.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if appAppearance == mode {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                        .font(.body.weight(.semibold))
                                }
                            }
                        }
                    }
                } header: {
                    Text("Theme")
                }
                
                Section {
                    Toggle(isOn: $showConfidence) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Show Detection Overlay")
                                .font(.body)
                            Text("Display bounding boxes and confidence scores on detected objects")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Detection Display")
                } footer: {
                    Text("When disabled, you'll see only the original photo without any overlays for a clean view.")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Minimum Confidence")
                                .font(.body)
                            Spacer()
                            Text(String(format: "%.0f%%", detectionSensitivity * 100))
                                .font(.body.weight(.semibold))
                                .foregroundColor(.blue)
                        }
                        
                        Slider(value: $detectionSensitivity, in: 0.1...0.95, step: 0.05)
                            .tint(.blue)
                        
                        HStack {
                            Text("Lenient (10%)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Strict (95%)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Detection Confidence")
                } footer: {
                    Text("Higher confidence = stricter detection (fewer false positives). Lower confidence = more lenient (may detect non-chips). For accurate poker chip counting, use 95%.")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Refresh Rate")
                                .font(.body)
                            Spacer()
                            Text(String(format: "%.1fs", liveRefreshRate))
                                .font(.body.weight(.semibold))
                                .foregroundColor(.purple)
                        }
                        
                        Slider(value: $liveRefreshRate, in: 0.1...2.0, step: 0.1)
                            .tint(.purple)
                        
                        HStack {
                            Text("Fast (0.1s)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Slow (2.0s)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Live Detection")
                } footer: {
                    Text("Controls how often the live detection refreshes. Lower values provide more frequent updates but use more processing power.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .preferredColorScheme(appAppearance.colorScheme)
        }
    }
}

/// Appearance mode options
enum AppearanceMode: String, CaseIterable {
    case light
    case dark
    case system
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
    
    var description: String {
        switch self {
        case .light: return "Always use light appearance"
        case .dark: return "Always use dark appearance"
        case .system: return "Match device settings"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

#Preview {
    AppearanceSettingsView()
}
