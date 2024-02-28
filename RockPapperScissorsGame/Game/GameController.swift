//
//  GameController.swift
//  RockPapperScissorsGame
//
//  Created by Kaua Miguel on 26/02/24.
//

import UIKit
import AVKit
import Vision

class GameController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{
    
    let gameView = GameView()
    
    let coreMlResult = CoreMLResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let outputData = AVCaptureVideoDataOutput()
        
        outputData.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Queue"))
        
        captureSession.addOutput(outputData)
        
       
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let buffer:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let dataModel = try? VNCoreMLModel(for:RockPapperScissorsModel().model) else { return }
        
        let request = VNCoreMLRequest(model: dataModel){ (res, error) in
            guard let result = res.results as? [VNClassificationObservation] else { return }
            
            guard let observationData = result.first else { return }
            
            print(observationData.identifier, observationData.confidence)
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: buffer, options: [:]).perform([request])
        
    }
    
}

extension GameController : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        
        guard let result = coreMlResult.result(image: image) else { return }
        
        print(result)
        
    }
}
