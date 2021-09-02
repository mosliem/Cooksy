//
//  GetIdResultManger.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/22/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

protocol getRecipeDataDelegate
{
    func didGetData(_ getIdResultManger : GetIdResultManger,recipeData : IdResultModel)
}


class GetIdResultManger
{
    
    var recipeInformation : IdResultModel?
    var getDataDelegate : getRecipeDataDelegate?
    func fetchIdData(id : Int)
    {
    let urlString = "https://api.spoonacular.com/recipes/\(id)/information?apiKey=b381d201a34a40ebb0b65b544978fc14&&includeNutrition=false"
    performRequest(urlString: urlString)
    }
    
    func performRequest(urlString:String)
    {
        let url = URL(string: urlString)
        let task = URLSession(configuration: .default).dataTask(with: url!) { data,_,error in
            if let e = error
            {
                print(e.localizedDescription)
            }
            if let safeData = data
            {
                self.parseJSON(data: safeData, parsingCompletion: ({ done in
                    self.getDataDelegate?.didGetData(self, recipeData: self.recipeInformation!)
                }))
                
            }
        }
        task.resume()
        
    }
    
    
    func parseJSON(data : Data , parsingCompletion : @escaping(Bool)->Void)
    {
        let decoder = JSONDecoder()
        do
        {
            var instruction : [String]? = []
            var ingredients : [String]? = []
            
            
            let decodedData = try decoder.decode(idResultData.self, from: data)
            for item in decodedData.extendedIngredients
            {
                ingredients?.append(item.original)
                
            }
            for index in 0 ..< decodedData.analyzedInstructions.count
            {
                let steps =  decodedData.analyzedInstructions[index].steps
                for i in 0 ..< steps.count
                {
                    instruction?.append(steps[i].step)
                }
            }
            downloadPhoto(url: decodedData.image) { (image) in
                self.recipeInformation = IdResultModel(title: decodedData.title, readyInMin: decodedData.readyInMinutes, serving: decodedData.servings, image: image, ingredients: ingredients!, instructionSteps: instruction!)
                  parsingCompletion(true)
            }
           
        }
        catch
        {
            print(error)
        }
    }
    
    
    func downloadPhoto(url : URL , imageDownloaded : @escaping (UIImage) -> Void )
    {
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            if let e = error {
                print(e.localizedDescription)
            }
            else if let safedata = data
            {
                let image = UIImage(data: safedata)
                imageDownloaded(image!)
            }
            
        }
        task.resume()
    }
}
