//
//  lovedRecipeCell.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/28/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class lovedRecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    
    var id : Int?
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }


    
}
