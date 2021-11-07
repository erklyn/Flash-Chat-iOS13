//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController {

    var charIndex = 0.0
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        titleLabel.text = ""
        
        let loopedText = "⚡️FlashChat"
        for letter in loopedText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { Timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        

       
    }
    

}
