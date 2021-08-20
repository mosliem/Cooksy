//
//  SearchViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/14/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,getResultDelegate
{
    
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    @IBOutlet weak var SearchTableView: UITableView!
    var items : [SearchItem] = []
    
    let searchManger = SearchResultManger()
    let activityview = UIView(frame:CGRect(x: 150 , y: 390, width: 100, height: 100))
    let NotFoundLabel = UILabel(frame: CGRect(x: 150, y: 390, width: 100, height: 100))
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        recipeSearchBar.placeholder = "Search recipes"
        SearchTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        
        //delegate
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
        recipeSearchBar.delegate = self
        searchManger.delegate = self
        updateUI()
       
    }
    func getResult(_searchResultManger: SearchResultManger, results: [SearchItem])
    {
        print("delegated")
        DispatchQueue.main.async
        {
            self.activityview.removeFromSuperview()
        }
        if results.count == 0
        {
            DispatchQueue.main.async {
                self.NotFoundLabel.text = "Not Found!"
                self.NotFoundLabel.textColor = UIColor.black
                self.NotFoundLabel.textAlignment = .center
                self.view.addSubview(self.NotFoundLabel)
            }
        }
        else
        {
            items = results
            updateUI()
        }
    }
    func updateUI()
    {
        print("update")
        DispatchQueue.main.async
        {
        self.SearchTableView.reloadData()
        }
    }
    func clearUI()
    {
        items = []
        
        DispatchQueue.main.async {
            self.NotFoundLabel.removeFromSuperview()
            self.SearchTableView.reloadData()
        }
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

//MARK:- SearchBarDelegate

extension SearchViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print("HI")
        DispatchQueue.main.async
            {
                self.clearUI()
                //creating and ADDING Activity Indicator
                self.activityview.backgroundColor = UIColor.white
                let loading = UIActivityIndicatorView(frame: CGRect(x: -25, y: -25, width: 150, height: 150 ))
                loading.hidesWhenStopped = true
                loading.startAnimating()
                self.activityview.addSubview(loading)
                self.view.addSubview(self.activityview)
        }
        searchBar.endEditing(true)
    }
   
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        print("hiha")
        if searchBar.text == ""
        {
            searchBar.placeholder = "Type something!"
            return false
        }
        else
        {
            return true
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchManger.fetchResult(query: searchBar.text!)
        print("fetched")
    }
}
