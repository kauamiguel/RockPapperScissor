//
//  GameController.swift
//  RockPapperScissorsGame
//
//  Created by Kaua Miguel on 26/02/24.
//

import UIKit

class GameController : UIViewController{
    
    let gameView = GameView()
    
    let coreMlResult = CoreMLResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameView.setupView(view: self.view)
        gameView.takePictureButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
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
