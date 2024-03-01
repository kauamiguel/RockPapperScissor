//
//  Bot_opponent.swift
//  RockPapperScissorsGame
//
//  Created by Daniel Ishida on 29/02/24.
//

import Foundation
import UIKit

class BotOpponent{
    var image : UIImage?
    var loop : Bool = true
    var currentIndex = 0
    let imageNames = ["rock", "paper", "scissors"]
    
    //MARK: Function that choses a random move to play
    func randomPlay(){
        var random = Int.random(in: 0...2)
        
        while currentIndex == random{
            random = Int.random(in: 0...2)
        }
        
        currentIndex = random
        
        switch random{
        case 0:
            self.image = UIImage(named: imageNames[0])
        case 1:
            self.image = UIImage(named: imageNames[1])
        case 2:
            self.image = UIImage(named: imageNames[2])
            
        default:
           break
        }
        
    }
    
    //MARK: Get image
    func getImage() -> UIImage{
        guard let img = self.image else{
            fatalError("Image is nil")
        }
        
        return img
    }
    
    //MARK: Get&Set Loop
    
    func setLoop(_ input : Bool){
        self.loop = input
    }
    
    func getLoop() -> Bool{
        return loop
    }
    
    init(image: UIImage? = nil, loop: Bool = true) {
        self.image = image
        self.loop = loop
        
        randomPlay()
    }
}




