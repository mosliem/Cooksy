//
//  lovedRecipeCell.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/28/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit
protocol getCellId {
    func fetchId(id : Int)
}
class lovedRecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var CellButton: UIButton!
    var id : Int?
    var fetchIdDelegate : getCellId?
    override func awakeFromNib()
    {
        super.awakeFromNib()
        titleLabel.font = UIFont(font: FontFamily.NovelSansPro.regular, size: 20)
        recipeImage.layer.borderWidth = 1
        recipeImage.layer.borderColor = UIColor.white.cgColor
        recipeImage.clipsToBounds = true
        recipeImage.layer.cornerRadius = recipeImage.frame.height/20
        cellBackgroundView.layer.cornerRadius = cellBackgroundView.frame.height/20
        CellButton.layer.cornerRadius = cellBackgroundView.frame.height/20
        
    }
    @IBAction func cellPressed(_ sender: UIButton)
    {
        fetchIdDelegate?.fetchId(id: id!)
        CellButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            self.CellButton.backgroundColor = UIColor.clear
        }
       
        
    }
}

