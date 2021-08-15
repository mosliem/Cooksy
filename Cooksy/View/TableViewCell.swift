//
//  TableViewCell.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/14/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImageViewRight: UIImageView!
    
    @IBOutlet weak var recipeTitleRight: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var recipeImageViewLeft: UIImageView!
    @IBOutlet weak var recipeTitleLeft: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        recipeTitleRight.layer.cornerRadius = recipeTitleRight.frame.height/25
        recipeImageViewRight.layer.borderWidth = 1
        recipeImageViewRight.clipsToBounds = true
        recipeImageViewRight.layer.cornerRadius = recipeImageViewRight.frame.height/25
        recipeImageViewRight.contentMode = .scaleAspectFill
        recipeImageViewRight.layer.borderColor = UIColor.clear.cgColor
        
        
        recipeTitleLeft.layer.cornerRadius = recipeTitleLeft.frame.height/25
        recipeImageViewLeft.layer.borderWidth = 1
        recipeImageViewLeft.clipsToBounds = true
        recipeImageViewLeft.layer.cornerRadius = recipeImageViewLeft.frame.height/25
        recipeImageViewLeft.contentMode = .scaleAspectFill
        recipeImageViewLeft.layer.borderColor = UIColor.white.cgColor
        
        
        
        leftButton.layer.cornerRadius = leftButton.frame.height/25
        rightButton.layer.cornerRadius = rightButton.frame.height/25
    }
    
    @IBAction func RightIsPressed(_ sender: UIButton)
    {
        rightButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            self.rightButton.backgroundColor = UIColor.clear
        }
        print("rightIsPressed")
    }
    @IBAction func leftIsPressed(_ sender: UIButton)
    {
        leftButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            self.leftButton.backgroundColor = UIColor.clear
        }
        print("left is pressed")
    }
    
}
