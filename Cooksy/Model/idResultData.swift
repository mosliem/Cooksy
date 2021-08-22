//
//  idResultData.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/22/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import Foundation
struct idResult : Codable
{
    let title : String
    let readyInMinutes : Int
    let servings : Int
    let image: URL
    let extendedIngredients : [ingredients]
    let analyzedInstructions : [instruction]
    
}

struct ingredients : Codable
{
    let name : String
    let amount : Double
    let unit : String
}

struct instruction : Codable
{
    let steps : [step]
}
struct step : Codable
{
    let number : Int
    let step : String
}
