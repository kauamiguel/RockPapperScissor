import UIKit
import AVKit
import Vision

class GameController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let gameView = GameView()
    let coreMlResult = CoreMLResult()
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var isCameraPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let outputData = AVCaptureVideoDataOutput()
        
        outputData.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Queue"))
        
        captureSession.addOutput(outputData)
        
        // Add a button to freeze/unfreeze the camera frame
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 40
        let buttonX = (view.frame.width - buttonWidth) / 2 // Center horizontally
        let buttonY = view.frame.height - buttonHeight - 20 // Place at the bottom with some padding
        
        let freezeButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
        freezeButton.setTitle("Freeze", for: .normal)
        freezeButton.addTarget(self, action: #selector(toggleCameraFreeze), for: .touchUpInside)
        view.addSubview(freezeButton)
    }
    
    @objc func toggleCameraFreeze() {
        if isCameraPaused {
            captureSession.startRunning()
        } else {
            captureSession.stopRunning()
        }
        isCameraPaused = !isCameraPaused
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard !isCameraPaused else { return } // Don't process frames if camera is paused
        
        guard let dataModel = try? VNCoreMLModel(for: RockPapperScissorsModel().model) else { return }
        
        let request = VNCoreMLRequest(model: dataModel) { (res, error) in
            guard let result = res.results as? [VNClassificationObservation] else { return }
            
            guard let observationData = result.first else { return }
            
            print(observationData.identifier, observationData.confidence)
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: buffer, options: [:]).perform([request])
    }
    
}

extension GameController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        guard let result = coreMlResult.result(image: image) else { return }
        
        print(result)
    }
}
