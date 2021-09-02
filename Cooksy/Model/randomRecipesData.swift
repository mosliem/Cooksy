//
//  randomRecipesData.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/31/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import Foundation

struct randomData : Decodable
{
    var recipes : [recipe]
}
struct recipe : Decodable
{
    var id : Int
    var title : String
    var readyInMinutes : Int
    var servings : Int
    var image : URL
}

