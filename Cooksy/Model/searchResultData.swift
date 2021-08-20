//
//  searchResultData.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/15/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import Foundation

struct searchResultData : Decodable
{
    let results : [Results]
    let number : Int
    let totalResults: Int
}

struct Results : Decodable
{
    let id : Int
    let title : String
    let image : String
}
