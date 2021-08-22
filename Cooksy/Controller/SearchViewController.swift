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
    
    var items1 : [SearchItem] = []
    var items2 : [SearchItem] = []
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
            for index in  0 ..< (results.count)/2
            {
                items1.append(results[index])
            }
            for index in (results.count)/2 ..< (results.count)
            {
                items2.append(results[index])
            }
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
        items1 = []
        items2 = []
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
        return (items1.count+items2.count)/2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = SearchTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TableViewCell
        
        cell.recipeImageViewRight.image = items1[indexPath.row].recipeImage
        cell.recipeTitleRight.text = items1[indexPath.row].title
        cell.rightId = items1[indexPath.row].id
        
        cell.recipeImageViewLeft.image = items2[indexPath.row].recipeImage
        cell.recipeTitleLeft.text = items2[indexPath.row].title
        cell.leftId = items2[indexPath.row].id
        return cell
    }
    
    
}

//MARK:- SearchBarDelegate

extension SearchViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
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
