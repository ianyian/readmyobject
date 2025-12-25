//
//  ContentView.swift
//  readmyobject
//
//  Created by XJ on 24/12/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChipDetectionViewModel()
    @AppStorage("appAppearance") private var appAppearance: AppearanceMode = .system
    @AppStorage("showConfidence") private var showConfidence: Bool = false
    @AppStorage("detectionSensitivity") private var detectionSensitivity: Double = 0.95
    @AppStorage("detectionMode") private var detectionModeRaw: String = DetectionMode.allObjects.rawValue
    @State private var showCamera = false
    @State private var showLiveDetection = false
    
    private var detectionMode: DetectionMode {
        DetectionMode(rawValue: detectionModeRaw) ?? .allObjects
    }
    @State private var showPhotoPicker = false
    @State private var capturedImage: UIImage?
    @State private var showResults = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            mainContent
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        // Mode Picker
                        Menu {
                            Picker("Detection Mode", selection: $detectionModeRaw) {
                                ForEach(DetectionMode.allCases, id: \.self) { mode in
                                    Label(mode.displayName, systemImage: mode.icon)
                                        .tag(mode.rawValue)
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: detectionMode.icon)
                                    .font(.body)
                                Text(detectionMode.displayName)
                                    .font(.subheadline)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                            }
                            .foregroundColor(.blue)
                        }
                        
                        // Settings Button
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(selectedImage: $capturedImage)
            }
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPicker(selectedImage: $capturedImage)
            }
            .sheet(isPresented: $showSettings) {
                AppearanceSettingsView()
            }
            .fullScreenCover(isPresented: $showLiveDetection) {
                NavigationView {
                    LiveDetectionView(detectionMode: detectionMode)
                }
            }
            .onChange(of: detectionModeRaw) { _ in
                // Update viewModel when mode changes
                viewModel.detectionMode = detectionMode
            }
            .onChange(of: capturedImage) { newImage in
                if let image = newImage {
                    viewModel.confidenceThreshold = Float(detectionSensitivity)
                    viewModel.detectionMode = detectionMode
                    viewModel.detectChips(in: image)
                }
            }
            .onChange(of: viewModel.detectionResult) { result in
                if result != nil {
                    showResults = true
                }
            }
            .sheet(isPresented: $showResults, onDismiss: {
                capturedImage = nil
                viewModel.reset()
            }) {
                resultView
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
            .preferredColorScheme(appAppearance.colorScheme)
        }
    }
    
    private var mainContent: some View {
        ZStack {
            VStack(spacing: 30) {
                headerSection
                
                Spacer()
                
                actionButtons
                
                Spacer()
            }
            
            if viewModel.isProcessing {
                processingOverlay
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            Image(systemName: detectionMode.icon)
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text(detectionMode.headerTitle)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
        }
        .padding(.top, 50)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 20) {
            Button(action: {
                showCamera = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                    Text("Take Photo")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            
            Button(action: {
                showPhotoPicker = true
            }) {
                HStack {
                    Image(systemName: "photo.fill")
                        .font(.title2)
                    Text("Choose from Library")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            
            Button(action: {
                showLiveDetection = true
            }) {
                HStack {
                    Image(systemName: "video.fill")
                        .font(.title2)
                    Text("Live Detection")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
        }
        .padding(.horizontal, 30)
    }
    
    private var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                Text("Detecting chips...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Material.thick)
            )
            .shadow(radius: 10)
        }
    }
    
    private var resultView: some View {
        Group {
            if let result = viewModel.detectionResult {
                NavigationView {
                    DetectionResultView(result: result, showConfidence: showConfidence)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    showResults = false
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
