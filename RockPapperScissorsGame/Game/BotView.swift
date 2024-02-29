//
//  BotView.swift
//  RockPapperScissorsGame
//
//  Created by Daniel Ishida on 29/02/24.
//

import Foundation
import UIKit

class BotOpponentViewController: UIViewController {
    
    private let botOpponent = BotOpponent()
    private var imageView: UIImageView!
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create UIImageView to display the bot opponent's image
             imageView = UIImageView()
             imageView.contentMode = .scaleAspectFit
             imageView.translatesAutoresizingMaskIntoConstraints = false
             view.addSubview(imageView)
             
             // Add Auto Layout constraints to center the image view
             NSLayoutConstraint.activate([
                 imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                 imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                 imageView.widthAnchor.constraint(equalToConstant: 200), // Adjust as needed
                 imageView.heightAnchor.constraint(equalToConstant: 200) // Adjust as needed
        ])
        
        // Start a timer to update the image at regular intervals
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
    }
    
    // Function to update the image view with the current bot opponent's image
    @objc private func updateImage() {
        botOpponent.randomPlay()
        let image = botOpponent.getImage()
        imageView.image = image
    }
    
    // Invalidate the timer when the view controller is removed from the hierarchy
    deinit {
        timer?.invalidate()
    }
}
