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
    
    //MARK: Function that choses a random move to play
    func randomPlay(){
            let random = Int.random(in: 0...2)
            
            switch random{
            case 0:
                self.image = UIImage(named: "Rock")
            case 1:
                self.image = UIImage(named: "Paper")
            case 2:
                self.image = UIImage(named: "Scissor")
                
            default:
                fatalError("Out of scope")
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




