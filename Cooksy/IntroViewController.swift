//
//  ViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/6/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var StartButton: UIButton!
    var charIndex = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()
        StartButton.layer.cornerRadius = StartButton.frame.height/8
        StartButton.isHidden = true
        navigationController?.navigationBar.isHidden = true

        // title Animation
        titleLabel.text = ""
        let text = "Cooksy"
        // title animaton loop
          for letter in text
          {
              Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats:false) { (timer) in
                  self.titleLabel.text?.append(letter)
              }
                 charIndex += 1
          }
     
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            self.StartButton.isHidden = false
        }
        
    }
    @IBAction func startButtonPressed0(_ sender: UIButton) {
        performSegue(withIdentifier: "introToLogin", sender: self)
    }
    

}



