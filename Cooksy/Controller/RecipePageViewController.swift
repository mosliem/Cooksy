//
//  RecipePageViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/23/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class RecipePageViewController: UIViewController , getRecipeDataDelegate
{
    
    let loadingView = UIView(frame: CGRect(x: 150, y: 390, width: 100, height: 100))
    var Data : IdResultModel?
    let recipeDataManger = GetIdResultManger()
    var id : Int?
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var RecipescrollView: UIScrollView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navBar.isHidden = true
        loadingScreen()
        recipeDataManger.getDataDelegate = self
        fetchData()
    }
    override func viewDidLayoutSubviews()
    {
        RecipescrollView.contentSize = CGSize(width: view.frame.size.width, height: 1000)
        
        
        //image view
        let outerImageView = UIView(frame: CGRect(x: view.center.x-185, y:20, width: 370, height: 410))
        let imageView = UIImageView(frame: outerImageView.bounds)
        imageView.image = Data?.image
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        outerImageView.clipsToBounds = false
        outerImageView.layer.shadowColor = UIColor.black.cgColor
        outerImageView.layer.shadowRadius = 10
        outerImageView.layer.shadowOpacity = 0.3
        outerImageView.layer.shadowOffset = CGSize.zero
        outerImageView.layer.shadowPath = UIBezierPath(roundedRect: outerImageView.bounds, cornerRadius: 10).cgPath
        outerImageView.addSubview(imageView)
        
        RecipescrollView.addSubview(outerImageView)
        
        
        //title Label
        let titleLabel = UILabel(frame: CGRect(x: view.center.x-150, y: 450, width: 300, height: 50))
        print(view.center.x)
        titleLabel.text = Data?.title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        RecipescrollView.addSubview(titleLabel)
        
                
    }
    
    func loadingScreen()
    {
        print("loading")
        let loadingIcon = UIActivityIndicatorView(frame: CGRect(x: -25, y: -25, width: 150, height: 150))
        loadingIcon.hidesWhenStopped = true
        loadingIcon.startAnimating()
        loadingView.addSubview(loadingIcon)
        self.view.addSubview(loadingView)
    }
    
    func fetchData()
    {
        recipeDataManger.fetchIdData(id: id!)
    }
    
    func didGetData(_ getIdResultManger: GetIdResultManger, recipeData: IdResultModel) {
        print("done")
        Data = recipeData
        DispatchQueue.main.async
            {
                self.loadingView.removeFromSuperview()
                self.navBar.isHidden = false
           }
    }
    
    
    
}

