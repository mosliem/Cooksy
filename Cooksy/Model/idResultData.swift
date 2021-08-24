//
//  idResultData.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/22/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import Foundation
struct idResultData : Decodable
{
    let title : String
    let readyInMinutes : Int
    let servings : Int
    let image: URL
    let extendedIngredients : [ingredients]
    let analyzedInstructions : [instruction]
    
}

struct ingredients : Decodable
{
    let original : String
}
struct instruction : Decodable
{
    let steps : [step]
}
struct step : Decodable
{
    let step : String
}
