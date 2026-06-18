@preconcurrency import AVFoundation
import SwiftUI

struct QRCodeScannerView: UIViewControllerRepresentable {
    let onScanned: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> QRCodeScannerViewController {
        let controller = QRCodeScannerViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_: QRCodeScannerViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onScanned: onScanned)
    }

    final class Coordinator: NSObject, QRCodeScannerViewControllerDelegate {
        let onScanned: (String) -> Void

        init(onScanned: @escaping (String) -> Void) {
            self.onScanned = onScanned
        }

        func didScanQRCode(_ value: String) {
            onScanned(value)
        }
    }
}

protocol QRCodeScannerViewControllerDelegate: AnyObject {
    func didScanQRCode(_ value: String)
}

final class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: QRCodeScannerViewControllerDelegate?

    private nonisolated(unsafe) let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isProcessing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCamera()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.stopRunning()
            }
        }
    }

    private func setupCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        }

        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        previewLayer = layer
    }

    nonisolated func metadataOutput(
        _: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from _: AVCaptureConnection
    ) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue
        else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self, !self.isProcessing else { return }
            isProcessing = true
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didScanQRCode(stringValue)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isProcessing = false
            }
        }
    }
}
