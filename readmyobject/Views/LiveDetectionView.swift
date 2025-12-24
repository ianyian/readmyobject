//
//  LiveDetectionView.swift
//  readmyobject
//
//  Created by XJ on 24/12/2025.
//

import SwiftUI
import AVFoundation
import Vision
import Combine
import CoreML

struct LiveDetectionView: View {
    @StateObject private var viewModel: LiveDetectionViewModel
    @AppStorage("detectionSensitivity") private var detectionSensitivity: Double = 0.95
    @AppStorage("liveDetectionRefreshRate") private var refreshRate: Double = 0.5
    @AppStorage("appAppearance") private var appAppearance: AppearanceMode = .system
    @Environment(\.dismiss) var dismiss
    
    let detectionMode: DetectionMode
    
    init(detectionMode: DetectionMode) {
        self.detectionMode = detectionMode
        _viewModel = StateObject(wrappedValue: LiveDetectionViewModel(detectionMode: detectionMode))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Camera Stream - 68% of screen (increased from 60%)
                ZStack {
                    CameraStreamView(
                        viewModel: viewModel,
                        refreshRate: refreshRate,
                        confidenceThreshold: Float(detectionSensitivity)
                    )
                    .frame(height: geometry.size.height * 0.68)
                    .onTapGesture {
                        viewModel.togglePause()
                    }
                    
                    // Mode indicator and pause status overlay
                    VStack {
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: detectionMode.icon)
                                Text(detectionMode.displayName)
                                    .font(.subheadline.weight(.semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(8)
                            .padding()
                            
                            Spacer()
                        }
                        
                        // Pause indicator in center
                        if viewModel.isPaused {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "pause.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 8)
                                
                                Text("Paused")
                                    .font(.title2.weight(.semibold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 4)
                                
                                Text("Tap to Resume")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                                    .shadow(color: .black.opacity(0.5), radius: 4)
                            }
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(16)
                            Spacer()
                        } else {
                            Spacer()
                        }
                    }
                }
                
                // Chart Area - 32% of screen (both charts, reduced by 20%)
                DetectionChartView(viewModel: viewModel)
                    .frame(height: geometry.size.height * 0.32)
                    .background(Color(uiColor: .systemBackground))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Live Detection")
                    .font(.headline)
            }
        }
        .preferredColorScheme(appAppearance.colorScheme)
        .onAppear {
            viewModel.startDetection(
                refreshRate: refreshRate,
                confidenceThreshold: Float(detectionSensitivity)
            )
        }
        .onDisappear {
            viewModel.stopDetection()
        }
    }
}

// MARK: - Camera Stream View
struct CameraStreamView: UIViewRepresentable {
    @ObservedObject var viewModel: LiveDetectionViewModel
    let refreshRate: Double
    let confidenceThreshold: Float
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.backgroundColor = .black
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        if uiView.session == nil {
            uiView.session = viewModel.captureSession
        }
    }
}

class CameraPreviewView: UIView {
    var session: AVCaptureSession? {
        didSet {
            guard let session = session else { return }
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = bounds
            previewLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
}

// MARK: - Detection Chart View
struct DetectionChartView: View {
    @ObservedObject var viewModel: LiveDetectionViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            // Detection Header
            HStack {
                Text("Detection History")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("Total: \(viewModel.currentTotalCount)")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Stacked Bar Chart
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom, spacing: 4) {
                            ForEach(viewModel.detectionHistory.indices.reversed(), id: \.self) { index in
                                StackedBarView(
                                    data: viewModel.detectionHistory[index],
                                    maxHeight: geometry.size.height * 0.45,
                                    maxValue: viewModel.maxHistoryValue
                                )
                                .frame(width: 30)
                                .id(index)
                            }
                        }
                        .padding(.horizontal, 8)
                        .rotationEffect(.degrees(0))
                        .scaleEffect(x: -1, y: 1)
                    }
                    .scaleEffect(x: -1, y: 1)
                    .onChange(of: viewModel.detectionHistory.count) { _ in
                        // Auto-scroll to show latest on the right
                        if let lastIndex = viewModel.detectionHistory.indices.last {
                            withAnimation {
                                proxy.scrollTo(lastIndex, anchor: .leading)
                            }
                        }
                    }
                }
            }
            
            Divider()
                .padding(.horizontal)
            
            // CPU Usage Header
            HStack {
                Text("CPU Usage")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(String(format: "%.1f%%", viewModel.currentCPUUsage))
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.orange)
            }
            .padding(.horizontal)
            
            // CPU Line Chart with Y-axis
            GeometryReader { geometry in
                HStack(spacing: 4) {
                    // Y-axis labels
                    VStack(spacing: 0) {
                        Text(String(format: "%.0f%%", viewModel.cpuMaxScale))
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.0f%%", viewModel.cpuMaxScale / 2))
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("0%")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 30, height: geometry.size.height * 0.45)
                    
                    // Chart area
                    ZStack {
                        // Background grid lines
                        VStack(spacing: 0) {
                            Divider().opacity(0.3)
                            Spacer()
                            Divider().opacity(0.2)
                            Spacer()
                            Divider().opacity(0.3)
                        }
                        .frame(height: geometry.size.height * 0.45)
                        
                        // Scrollable chart
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .bottom, spacing: 0) {
                                    ForEach(viewModel.cpuHistory.indices.reversed(), id: \.self) { index in
                                        CPULineSegment(
                                            current: viewModel.cpuHistory[index],
                                            next: index > 0 ? viewModel.cpuHistory[index - 1] : nil,
                                            maxHeight: geometry.size.height * 0.45,
                                            maxValue: viewModel.cpuMaxScale
                                        )
                                        .frame(width: 30)
                                        .id(index)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .scaleEffect(x: -1, y: 1)
                            }
                            .scaleEffect(x: -1, y: 1)
                            .onChange(of: viewModel.cpuHistory.count) { _ in
                                if let lastIndex = viewModel.cpuHistory.indices.last {
                                    withAnimation {
                                        proxy.scrollTo(lastIndex, anchor: .leading)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 8)
        }
    }
}

// MARK: - Stacked Bar View
struct StackedBarView: View {
    let data: DetectionHistoryEntry
    let maxHeight: CGFloat
    let maxValue: Int
    
    private let colorPalette: [Color] = [
        .blue, .green, .orange, .purple, .pink, .red, .yellow, .cyan
    ]
    
    var body: some View {
        VStack(spacing: 2) {
            if data.labelCounts.isEmpty {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4)
            } else {
                let total = data.totalCount
                let heightRatio = maxValue > 0 ? CGFloat(total) / CGFloat(maxValue) : 0
                let barHeight = max(4, heightRatio * maxHeight)
                
                VStack(spacing: 0) {
                    ForEach(Array(data.labelCounts.enumerated()), id: \.offset) { index, item in
                        let segmentRatio = CGFloat(item.count) / CGFloat(total)
                        let segmentHeight = barHeight * segmentRatio
                        
                        Rectangle()
                            .fill(colorForLabel(item.label, index: index))
                            .frame(height: max(2, segmentHeight))
                    }
                }
                .cornerRadius(2)
            }
            
            Text("\(data.totalCount)")
                .font(.system(size: 8))
                .foregroundColor(.secondary)
        }
    }
    
    private func colorForLabel(_ label: String, index: Int) -> Color {
        // Use consistent color for same label
        let hash = abs(label.hashValue)
        return colorPalette[hash % colorPalette.count]
    }
}

// MARK: - Detection History Entry
struct DetectionHistoryEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let totalCount: Int
    let labelCounts: [(label: String, count: Int)]
}

// MARK: - CPU Line Segment
struct CPULineSegment: View {
    let current: Double
    let next: Double?
    let maxHeight: CGFloat
    let maxValue: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                let currentHeight = min(maxHeight, maxHeight * CGFloat(current / maxValue))
                
                // Line to next point (no fill, just clean line)
                if let next = next {
                    let nextHeight = min(maxHeight, maxHeight * CGFloat(next / maxValue))
                    
                    // Main line only
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geometry.size.height - currentHeight))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height - nextHeight))
                    }
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                } else {
                    // Last point - just a small indicator
                    Circle()
                        .fill(Color.green)
                        .frame(width: 4, height: 4)
                        .offset(y: -currentHeight)
                }
            }
        }
    }
}

// MARK: - Live Detection View Model
class LiveDetectionViewModel: ObservableObject {
    @Published var detectionHistory: [DetectionHistoryEntry] = []
    @Published var currentTotalCount: Int = 0
    @Published var maxHistoryValue: Int = 1
    @Published var cpuHistory: [Double] = []
    @Published var currentCPUUsage: Double = 0.0
    @Published var cpuMaxScale: Double = 10.0
    @Published var isPaused: Bool = false
    
    let captureSession = AVCaptureSession()
    private var videoOutput = AVCaptureVideoDataOutput()
    private var captureDelegate: CaptureDelegate?
    private var detectionTimer: Timer?
    private var cpuMonitorTimer: Timer?
    private var lastDetectionTime = Date()
    private var currentRefreshRate: Double = 0.5
    private var currentConfidenceThreshold: Float = 0.95
    
    private var chipModel: VNCoreMLModel?
    private var standardModel: VNCoreMLModel?
    private var detectionMode: DetectionMode
    
    private let maxHistoryEntries = 30 // Keep last 30 entries
    
    init(detectionMode: DetectionMode) {
        self.detectionMode = detectionMode
        loadModels()
    }
    
    private func loadModels() {
        let config = MLModelConfiguration()
        config.computeUnits = .all
        
        // Load chip model
        if let chipModelURL = Bundle.main.url(forResource: "best", withExtension: "mlmodelc"),
           let mlModel = try? MLModel(contentsOf: chipModelURL, configuration: config) {
            chipModel = try? VNCoreMLModel(for: mlModel)
            print("✅ Loaded chip model for live detection")
        }
        
        // Load standard model
        if let standardModelURL = Bundle.main.url(forResource: "yolov8n", withExtension: "mlmodelc"),
           let mlModel = try? MLModel(contentsOf: standardModelURL, configuration: config) {
            standardModel = try? VNCoreMLModel(for: mlModel)
            print("✅ Loaded standard model for live detection")
        }
    }
    
    func startDetection(refreshRate: Double, confidenceThreshold: Float) {
        self.currentRefreshRate = refreshRate
        self.currentConfidenceThreshold = confidenceThreshold
        
        setupCamera()
        startCapturing()
        startCPUMonitoring()
    }
    
    func stopDetection() {
        captureSession.stopRunning()
        detectionTimer?.invalidate()
        detectionTimer = nil
        cpuMonitorTimer?.invalidate()
        cpuMonitorTimer = nil
    }
    
    func togglePause() {
        isPaused.toggle()
        
        if isPaused {
            // Pause: stop detection timer but keep camera and CPU monitoring running
            detectionTimer?.invalidate()
            detectionTimer = nil
            print("⏸️ Detection paused - history updates stopped, CPU monitoring continues")
        } else {
            // Resume: restart detection timer (CPU already running)
            startCapturing()
            print("▶️ Detection resumed")
        }
    }
    
    private func setupCamera() {
        captureSession.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("❌ Failed to setup camera")
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        captureDelegate = CaptureDelegate(viewModel: self)
        videoOutput.setSampleBufferDelegate(captureDelegate, queue: DispatchQueue(label: "videoQueue"))
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    private func startCapturing() {
        // Process frames at the specified refresh rate
        detectionTimer = Timer.scheduledTimer(withTimeInterval: currentRefreshRate, repeats: true) { _ in
            // Timer just tracks intervals, actual processing happens in delegate
        }
    }
    
    private func startCPUMonitoring() {
        // Monitor CPU every 0.5 seconds independently of detection
        cpuMonitorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateCPUUsage()
        }
    }
    
    func detectObjects(in sampleBuffer: CMSampleBuffer) {
        // Skip detection if paused
        guard !isPaused else { return }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Use appropriate model(s) based on mode
        if detectionMode == .allObjects {
            // Run both models
            detectWithBothModels(ciImage: ciImage)
        } else {
            // Run single model
            let model = detectionMode == .pokerChips ? chipModel : standardModel
            guard let model = model else { return }
            detectWithSingleModel(ciImage: ciImage, model: model)
        }
    }
    
    func shouldProcessFrame() -> Bool {
        // Don't process if paused
        guard !isPaused else { return false }
        
        let now = Date()
        let timeSinceLastDetection = now.timeIntervalSince(lastDetectionTime)
        
        if timeSinceLastDetection >= currentRefreshRate {
            lastDetectionTime = now
            return true
        }
        return false
    }
    
    private func detectWithSingleModel(ciImage: CIImage, model: VNCoreMLModel) {
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self,
                  let results = request.results as? [VNRecognizedObjectObservation] else { return }
            
            DispatchQueue.main.async {
                self.processDetectionResults(results)
            }
        }
        request.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
    
    private func detectWithBothModels(ciImage: CIImage) {
        var allResults: [VNRecognizedObjectObservation] = []
        let group = DispatchGroup()
        
        if let standardModel = standardModel {
            group.enter()
            let request = VNCoreMLRequest(model: standardModel) { request, error in
                defer { group.leave() }
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    allResults.append(contentsOf: results)
                }
            }
            request.imageCropAndScaleOption = .scaleFill
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            try? handler.perform([request])
        }
        
        if let chipModel = chipModel {
            group.enter()
            let request = VNCoreMLRequest(model: chipModel) { request, error in
                defer { group.leave() }
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    allResults.append(contentsOf: results)
                }
            }
            request.imageCropAndScaleOption = .scaleFill
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            try? handler.perform([request])
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.processDetectionResults(allResults)
        }
    }
    
    @MainActor
    private func processDetectionResults(_ results: [VNRecognizedObjectObservation]) {
        var labelCounts: [String: Int] = [:]
        
        for observation in results {
            guard let label = observation.labels.first,
                  label.confidence >= currentConfidenceThreshold else { continue }
            
            // Filter by mode if not all objects
            if detectionMode != .allObjects && !detectionMode.matches(label: label.identifier) {
                continue
            }
            
            // Get display label
            let displayLabel: String
            if let classId = Int(label.identifier), classId >= 0 && classId <= 79 {
                displayLabel = cocoClassName(for: classId)
            } else {
                displayLabel = label.identifier
            }
            
            labelCounts[displayLabel, default: 0] += 1
        }
        
        let totalCount = labelCounts.values.reduce(0, +)
        let sortedCounts = labelCounts.sorted { $0.value > $1.value }.map { (label: $0.key, count: $0.value) }
        
        let entry = DetectionHistoryEntry(
            timestamp: Date(),
            totalCount: totalCount,
            labelCounts: sortedCounts
        )
        
        detectionHistory.append(entry)
        
        // Keep only last N entries
        if detectionHistory.count > maxHistoryEntries {
            detectionHistory.removeFirst()
        }
        
        currentTotalCount = totalCount
        maxHistoryValue = max(maxHistoryValue, totalCount)
    }
    
    private func updateCPUUsage() {
        let usage = getCPUUsage()
        currentCPUUsage = usage
        cpuHistory.append(usage)
        
        // Keep only last N entries
        if cpuHistory.count > maxHistoryEntries {
            cpuHistory.removeFirst()
        }
        
        // Calculate dynamic Y-axis scale
        updateCPUScale()
    }
    
    private func updateCPUScale() {
        guard !cpuHistory.isEmpty else {
            cpuMaxScale = 10.0
            return
        }
        
        let maxValue = cpuHistory.max() ?? 0.0
        
        // Smart scaling with nice round numbers
        // Always show data in proper range for easy viewing
        if maxValue <= 8 {
            cpuMaxScale = 10.0
        } else if maxValue <= 20 {
            cpuMaxScale = 25.0
        } else if maxValue <= 40 {
            cpuMaxScale = 50.0
        } else if maxValue <= 60 {
            cpuMaxScale = 75.0
        } else {
            cpuMaxScale = 100.0
        }
    }
    
    private func getCPUUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        
        let threadsResult = task_threads(mach_task_self_, &threadsList, &threadsCount)
        
        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            for index in 0..<Int(threadsCount) {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[index], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                guard infoResult == KERN_SUCCESS else {
                    continue
                }
                
                let threadBasicInfo = threadInfo
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                }
            }
            
            vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        }
        
        return min(100.0, totalUsageOfCPU)
    }
    
    private func cocoClassName(for classId: Int) -> String {
        let cocoClasses = [
            "person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat",
            "traffic light", "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat",
            "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe", "backpack",
            "umbrella", "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard", "sports ball",
            "kite", "baseball bat", "baseball glove", "skateboard", "surfboard", "tennis racket",
            "bottle", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple",
            "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake",
            "chair", "couch", "potted plant", "bed", "dining table", "toilet", "tv", "laptop",
            "mouse", "remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink",
            "refrigerator", "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"
        ]
        
        if classId >= 0 && classId < cocoClasses.count {
            return cocoClasses[classId]
        }
        return "object \(classId)"
    }
}

// MARK: - Video Capture Delegate
class CaptureDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    weak var viewModel: LiveDetectionViewModel?
    
    init(viewModel: LiveDetectionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let viewModel = viewModel else { return }
        
        // Only process if enough time has passed (according to refresh rate)
        if viewModel.shouldProcessFrame() {
            viewModel.detectObjects(in: sampleBuffer)
        }
    }
}
