import UIKit
import AVKit
import Vision

class GameController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let gameView = GameView()
    let coreMlResult = CoreMLResult()
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var isRunningTrue = true
    let imageView = UIImageView()
    
    private let opponent = BotOpponent()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configuring timer
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
        
        self.view.backgroundColor = .gray
        imagePosition()
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.previewLayer = previewLayer
        
        view.layer.addSublayer(previewLayer)
        
        previewLayer.frame = view.frame
        
        let outputData = AVCaptureVideoDataOutput()
        
        outputData.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Queue"))
        
        captureSession.addOutput(outputData)
        
        startCamera()
        
        // Add a button to freeze/unfreeze the camera frame
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 40
        let buttonX = (view.frame.width - buttonWidth) / 2 // Center horizontally
        let buttonY = view.frame.height - buttonHeight - 20 // Place at the bottom with some padding
        
        let freezeButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
        freezeButton.setTitle("Countdown", for: .normal)
        freezeButton.addTarget(self, action: #selector(toggleCameraFreeze), for: .touchUpInside)
        view.addSubview(freezeButton)
    }
    
    @objc private func updateImage() {
        opponent.randomPlay()
        let image = opponent.getImage()
        imageView.image = image
    }
    
    func imagePosition(){
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.zPosition = 2
        view.addSubview(imageView)
        
        // Add Auto Layout constraints to center the image view
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 180), // Adjust as needed
            imageView.heightAnchor.constraint(equalToConstant: 250) // Adjust as needed
        ])
    }
    
    func startCamera(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            captureSession.startRunning()
        }
    }
    
    @objc func toggleCameraFreeze() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            if isRunningTrue {
                captureSession.stopRunning()
                self.timer?.invalidate()
            } else {
                self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
                captureSession.startRunning()
            }
            
            isRunningTrue = !isRunningTrue
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let dataModel = try? VNCoreMLModel(for: RockPapperScissorsModel().model) else { return }
        
        let request = VNCoreMLRequest(model: dataModel) { (res, error) in
            guard let result = res.results as? [VNClassificationObservation] else { return }
            
            guard let observationData = result.first else { return }
        
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: buffer, options: [:]).perform([request])
    }
    
}
