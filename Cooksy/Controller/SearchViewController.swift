//
//  SearchViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/14/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController
{
    
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    @IBOutlet weak var SearchTableView: UITableView!
    var items : [SearchItem] = [SearchItem(recipeImage: UIImage(named: "MeAvatar")!, title: "ME"),SearchItem(recipeImage: UIImage(named: "intro")!, title: "ME1")]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        recipeSearchBar.placeholder = "Search recipes"
        SearchTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        
        //delegate
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
    }
    
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = SearchTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TableViewCell
     
            cell.recipeImageViewRight.image = items[indexPath.row].recipeImage
            cell.recipeTitleRight.text = items[indexPath.row].title
        cell.recipeImageViewLeft.image = items[indexPath.row+1].recipeImage
            cell.recipeTitleLeft.text = items[indexPath.row+1].title
      
        return cell
    }
    
    
}
