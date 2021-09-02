//
//  randomRecipesManger.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/31/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

protocol getRandomRecipes
{
    func didUpdateData(recipes : [randomRecipeModel])
}


class randomRecipesManger
{
    var recipes : [randomRecipeModel] = []
    var getRandomRecipeDelegate : getRandomRecipes?
    func fetchRecipes()
    {
        let url = "https://api.spoonacular.com/recipes/random?apiKey=951450d77a7f460c83f7d5f775fc8252&number=50"
        performRequest(url: url)
    }
    func performRequest(url : String)
    {
        let URl = URL(string: url)
        let task = URLSession(configuration: .default).dataTask(with: URl!){(data , _ , error) in
       
            if let e = error
            {
                print(e.localizedDescription)
            }
            else
            {
                if let safeData = data
                {
                    self.parseJSON(data: safeData) { (parsingCase) in
                    self.getRandomRecipeDelegate?.didUpdateData(recipes: self.recipes)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func parseJSON(data : Data, parsingCompletion : @escaping(Bool) -> Void)
    {
        let decoder = JSONDecoder()
        var index = 0
        do
        {
            let decodedData = try decoder.decode(randomData.self, from: data)
            print(decodedData)
           for item in decodedData.recipes
            {
                downloadImage(url: item.image) {(image) in
                    let newRecipe = randomRecipeModel(id: item.id, title: item.title, readyInMin: item.readyInMinutes, serving: item.servings, image: image)
                    print(newRecipe)
                    self.recipes.append(newRecipe)
                    
                    
                    index += 1
                    if index == decodedData.recipes.count-1
                    {
                        parsingCompletion(true)
                    }
                }
            }
            
            
        }
            
        catch
        {
            print("parsing error")
            print(error.localizedDescription)
            fetchRecipes()
        }
    }
    func downloadImage(url : URL , downloadCompletion : @escaping(UIImage)->Void)
    {
             let task = URLSession.shared.dataTask(with: url){(data,_,error) in
                
                if let e = error
                {
                    print(e.localizedDescription)
                }
                else
                {
                    if let safaData = data
                    {
                        let image = UIImage(data: safaData)
                        downloadCompletion(image!)
                    }
                }
            }
            task.resume()
        
    }
    
}
