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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        setNavigtionBarItems()
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

extension WelcomeViewController {
    func setNavigtionBarItems() {
     
        if #available(iOS 13.0, *) {
            let s =  UINavigationBar.appearance()
            s.backgroundColor = UIColor(named: K.BrandColors.blue)
            s.tintColor = UIColor.black
            //s.titleTextAttributes = NSFontAttributeName: UIFont.systemFont(ofSize: 25)
            //navigationController?.navigationBar.standardAppearance = appearance
            //navigationController?.navigationBar.scrollEdgeAppearance = appearance
            //navigationController?.navigationBar.compactAppearance = appearance
             } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = UIColor(named: K.BrandColors.blue)
        }
    }
    
}
