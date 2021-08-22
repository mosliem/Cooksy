//
//  SearchResultManger.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/15/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.

import UIKit

protocol getResultDelegate
{
    func getResult(_searchResultManger : SearchResultManger , results : [SearchItem])
}

class SearchResultManger
{
    let apiUrl = "https://api.spoonacular.com/recipes/complexSearch?apiKey=be5e81a5f44a4ac0a2af8a21add0e310"
    var results : [SearchItem] = []
    var delegate : getResultDelegate?
    
    func fetchResult(query : String)
    {
        let urlString = "\(apiUrl)&query=\(query)&number=100"
        performRequest(url: urlString)
    }
    func performRequest(url : String)
    {
        if let url = URL(string: url)
        {
            let session = URLSession(configuration: .default)
            let task  = session.dataTask(with: url){(data,_,error) in
                
                if let e = error
                {
                    print(e)
                }
                if let safeData = data
                {
                    print("true")
                    self.pasrseJSON(data: safeData, ParseCompletion: ({done in
                        if done
                        {
                            self.delegate?.getResult(_searchResultManger: self, results: self.results)
                        }
                    }))
                }
                
            }
            task.resume()
            
        }

    }
    
    func pasrseJSON(data:Data ,ParseCompletion :@escaping(Bool) -> Void)
    {
        print("parsed")
        print(data)
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(searchResultData.self, from: data)
            print("decoded")
            results = []
            var number : Int
            if decodedData.number > decodedData.totalResults
            {
                number = decodedData.totalResults
            }
            else
            {
                number = decodedData.number
            }
            // check if there is no result 
            if number ==  0
            {
                delegate?.getResult(_searchResultManger: self, results: results)
            }
            for index in 0 ..< number
            {
                downloadImage(url: decodedData.results[index].image, Imagecompletion: ({ downloadedImage in
                    self.results.append(SearchItem(recipeImage: downloadedImage!, title: decodedData.results[index].title,id: decodedData.results[index].id))
                    if index+1 == number
                    {
                        ParseCompletion(true)
                    }
                }))
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
}


func downloadImage(url : String , Imagecompletion : @escaping (UIImage?) -> Void)
{
  let url = URL(string: url)!
    var image:UIImage?
    let task = URLSession.shared.dataTask(with: url) { (data,_, error) in
      if let e = error
      {
        print(e.localizedDescription)
      }
      else
      {
        image = UIImage(data: data!)
        Imagecompletion(image)
      }
    }
    task.resume()
}
