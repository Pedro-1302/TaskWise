//
//  HomeViewController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 10/02/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var appTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appTitleLabel.text = ""
        
        runAppTitleAnimation()
    }
    
    func runAppTitleAnimation() {
        var charIndex = 0.0
        let titleText = K.appTitle
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.appTitleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex + 3.0, repeats: false) { timer in
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                self.runAppTitleAnimation()
            }
            
            self.appTitleLabel.text = ""
        }
    }
    
}

