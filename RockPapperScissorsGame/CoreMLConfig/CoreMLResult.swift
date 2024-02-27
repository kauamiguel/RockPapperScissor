//
//  CoreMLResult.swift
//  RockPapperScissorsGame
//
//  Created by Kaua Miguel on 26/02/24.
//

import CoreML
import UIKit

class CoreMLResult{
    
    private let model = try? RockPapperScissorsModel(configuration: .init())
    
    func result(image : UIImage) -> String?{
        guard let cgImage = image.cgImage else { return nil }
        if let pixelImage = ConvertImage.pixelBuffer(forImage: cgImage){
            guard let predict = try? self.model?.prediction(image: pixelImage) else { fatalError() }
            return predict.target
        }
        return nil
    }
}
