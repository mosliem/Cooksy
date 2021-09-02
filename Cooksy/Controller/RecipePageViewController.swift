//
//  RecipePageViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/23/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit
import Firebase

class RecipePageViewController: UIViewController , getRecipeDataDelegate
{
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let loadingView = UIView(frame: CGRect(x: 150, y: 390, width: 100, height: 100))
    var Data : IdResultModel?
    let recipeDataManger = GetIdResultManger()
    var id : Int?
    let lovedButton = UIButton()
    var loved : Bool = false
    let username = Auth.auth().currentUser?.displayName
    
    @IBOutlet weak var RecipescrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadingScreen()
        recipeDataManger.getDataDelegate = self
        fetchData()
        
    }
  
    
    // get the state of lovedButton if it true or fasle
    // and the call update UI
    func checkIfFav()
    {
        
        db.collection(username!).document("\(id!)").addSnapshotListener { (docSnapShot, _) in
            if let doc = docSnapShot?.data()
            {
                if let lovedState = doc["loved"] as? Bool
                {
                    self.loved = lovedState
                }
            }
            DispatchQueue.main.async
                {
                
                    self.loadingView.removeFromSuperview()
                    self.updateUI()
               }
        }
            
        
        
    }
    func fetchData()
    {
        recipeDataManger.fetchIdData(id: id!)
    }
    
    func didGetData(_ getIdResultManger: GetIdResultManger, recipeData: IdResultModel)
    {
        print("done")
        Data = recipeData
        checkIfFav()
       
    }
    

    func updateUI()
    {
        print("updated with detial")
        RecipescrollView.contentSize = CGSize(width: view.frame.size.width, height: 1900)
        RecipescrollView.backgroundColor = .systemGroupedBackground
            
        //imageView
        let outerImageView = UIView(frame: CGRect(x: 0, y: -45, width:view.frame.size.width , height: 410))
        let imageView = UIImageView(frame: outerImageView.bounds)
        imageView.image = Data?.image
        imageView.layer.cornerRadius = imageView.frame.height/25
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        outerImageView.clipsToBounds = false
        outerImageView.layer.shadowColor = UIColor.darkGray.cgColor
        outerImageView.layer.shadowRadius = outerImageView.frame.height/25
        outerImageView.layer.shadowOpacity = 0.1
        outerImageView.layer.shadowOffset = CGSize.zero
        outerImageView.layer.shadowPath = UIBezierPath(roundedRect: outerImageView.bounds, cornerRadius: 30).cgPath
        outerImageView.addSubview(imageView)
        RecipescrollView.addSubview(outerImageView)
        
        
        //title Label
        let outerTitleLabel = UILabel(frame: CGRect(x: view.center.x-175, y: 390, width: 350, height: 60))
        let titleLabel = UILabel(frame: outerTitleLabel.bounds)
        titleLabel.text = Data?.title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(font: FontFamily.NovelSansPro.regular, size: 20)
        titleLabel.layer.cornerRadius = titleLabel.frame.height/2
        titleLabel.clipsToBounds = true
        titleLabel.backgroundColor = .white
        
        //outer title Label
        outerTitleLabel.clipsToBounds = false
        outerTitleLabel.layer.cornerRadius = titleLabel.frame.height/2
        outerTitleLabel.layer.shadowRadius = titleLabel.frame.height/2
        outerTitleLabel.layer.shadowColor = UIColor.darkGray.cgColor
        outerTitleLabel.layer.shadowOffset = CGSize.zero
        outerTitleLabel.layer.shadowOpacity = 0.1
        outerTitleLabel.layer.shadowPath = UIBezierPath(roundedRect: outerTitleLabel.bounds, cornerRadius: titleLabel.frame.height/2).cgPath
        outerTitleLabel.addSubview(titleLabel)
        RecipescrollView.addSubview(outerTitleLabel)
        
        // time label
        let timelabel = UILabel(frame: CGRect(x:130 , y: 482, width: 80, height: 50))
        timelabel.text = "\(Data!.readyInMin) min"
        timelabel.font = UIFont(font: FontFamily.NovelSansPro.regular, size: 16)
        timelabel.textColor = .darkGray
        RecipescrollView.addSubview(timelabel)
        
        //time icon
        let timeIcon = UIImageView(frame: CGRect(x: 105, y: 495, width: 20, height: 20))
        timeIcon.image = UIImage(systemName: "clock")
        timeIcon.tintColor = .darkGray
        RecipescrollView.addSubview(timeIcon)
        
        
        //serving label
        let servingLabel = UILabel(frame: CGRect(x: 220, y: 496, width: 30, height: 20))
        servingLabel.text = " \(Data!.serving)"
        servingLabel.font = UIFont(font: FontFamily.NovelSansPro.regular, size: 16)
        servingLabel.textColor = .darkGray
        RecipescrollView.addSubview(servingLabel)
        
        //serving icon
        let servingIcon = UIImageView(frame: CGRect(x: 242, y: 495, width: 30, height: 20))
        servingIcon.image = UIImage(systemName:"person.3")
        servingIcon.tintColor = .darkGray
        RecipescrollView.addSubview(servingIcon)

        
        //ingredients Label
        let ingredientsLabel = UILabel(frame: CGRect(x: 27, y: 550, width: 300, height: 50))
        ingredientsLabel.text = "Ingredients"
        ingredientsLabel.textColor = .black
        ingredientsLabel.font = .boldSystemFont(ofSize: 20)
        RecipescrollView.addSubview(ingredientsLabel)
        
        //ingredients text view
        let textView = UITextView(frame: CGRect(x: 0, y: 610, width: view.frame.size.width, height: 590))
        for text in Data!.ingredients
        {
            textView.text.append(" • ")
            textView.text.append(text)
            textView.text.append("\n\n")
        }
        
        textView.font = UIFont(font: FontFamily.NovelSansPro.regular, size: 17)
        textView.textColor = .darkGray
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.backgroundColor = .white
        textView.layer.cornerRadius = textView.frame.height/20
        RecipescrollView.addSubview(textView)
        
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(fixedWidth, newSize.width), height:newSize.height)
       
        //stepLabel
        let label = UILabel(frame: CGRect(x: 24, y: 610+textView.frame.height+20 , width: 300, height: 50))
        label.text = "Step by Step Process"
        label.font = UIFont(font: FontFamily.LemonMilk.bold, size: 20)
        RecipescrollView.addSubview(label)
        
        //love button
        lovedButton.frame = CGRect(x: view.center.x+(RecipescrollView.frame.size.width/2)-70 , y: -25, width: 70, height: 70)
        lovedButton.backgroundColor = .clear
        lovedButton.imageView?.tintColor = .darkGray
        if loved
        {
         lovedButton.setImage(Asset.loveIconFill.image, for: .normal)
        }
        else
        {
            lovedButton.setImage(Asset.loveIcon.image, for: .normal)
        }
        lovedButton.imageView?.contentMode = .scaleAspectFit
        lovedButton.addTarget(self, action: #selector(lovedButtonPressed), for: .touchUpInside)
        RecipescrollView.addSubview(lovedButton)
        
        //back Button
        let backButton = UIButton(frame: CGRect(x: 0, y: -25, width: 70, height: 70))
        let backImage = UIImage(systemName: "chevron.left")
        backButton.setImage(backImage, for: .normal)
        backButton.imageView?.tintColor = .darkGray
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        RecipescrollView.addSubview(backButton)
        
   
        //textView for steps
        let instrctionsTextView = UITextView(frame: CGRect(x: 0, y: 610+textView.frame.height+90, width: view.frame.size.width, height: 650))
        var i : Int = 1
        instrctionsTextView.text.append("\n")
        for step in Data!.instructionSteps
        {
            instrctionsTextView.text.append(" \(i)) ")
            instrctionsTextView.text.append("\(step) \n\n")
            i += 1
            
        }
        
        instrctionsTextView.font = UIFont(font: FontFamily.NovelSansPro.regular, size: 17)
        instrctionsTextView.textColor = .darkGray
        instrctionsTextView.backgroundColor = .white
        instrctionsTextView.isSelectable = false
        instrctionsTextView.isScrollEnabled = false
        instrctionsTextView.font = .preferredFont(forTextStyle: .body)
        instrctionsTextView.layer.cornerRadius = instrctionsTextView.frame.height/20

        RecipescrollView.addSubview(instrctionsTextView)
        
        let fixedWidthInstruction = instrctionsTextView.frame.width
        let newSizeInstruction = instrctionsTextView.sizeThatFits(CGSize(width: fixedWidthInstruction, height: CGFloat.greatestFiniteMagnitude))
        instrctionsTextView.frame.size = CGSize(width: max(fixedWidthInstruction, newSizeInstruction.width), height:newSizeInstruction.height)
        let newSizeScroll = outerImageView.frame.height+titleLabel.frame.height+ingredientsLabel.frame.height+textView.frame.height+label.frame.height+instrctionsTextView.frame.height
        
        RecipescrollView.contentSize.height = newSizeScroll+180
    }
    
    @objc func lovedButtonPressed(sender : UIButton!)
    {
    
        if !loved
        {
            lovedButton.setImage(Asset.loveIconFill.image, for: .normal)
            loveRecipe(loved: true, name: Data!.title, Id: id!, image: Data!.image, time: Data!.readyInMin, serving: Data!.serving)
            loved = true
        }
        else
        {
            lovedButton.setImage(Asset.loveIcon.image, for: .normal)
            db.collection(username!).document("\(id!)").delete { (error) in
                if let e = error
                {
                    print(e.localizedDescription)
                }
            }
            loved = false
        }
    
    }
    
    @objc func backButtonPressed()
    {
        navigationController?.popViewController(animated: true)
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
    
    
    func loveRecipe(loved: Bool, name: String, Id: Int, image: UIImage, time: Int, serving: Int)
    {
        print("lovedDelegated")
        let id = String(Id)
        uploadImage(image: image, id: Id) { (imageURL) in
            self.db.collection(self.username!).document(id).setData([
                "loved" : loved ,
                "name" : name ,
                "id" : id ,
                "time" : time ,
                "serving" : serving,
                "imageURL" : imageURL
            ])
            
        }
    }
    
    func uploadImage(image : UIImage , id : Int, UploadCompleten: @escaping(String) -> Void )
    {
        let imageData = image.pngData()
        let ref = storage.child("recipesData/\(id)")
        
        ref.getMetadata { (meta, _) in
            if meta == nil
            {
                ref.putData(imageData!, metadata: nil){(_ ,error) in
                    print("not exist")
                    if let e = error
                    {
                        print(e.localizedDescription)
                    }
                    ref.downloadURL { (url, _) in
                        UploadCompleten(url!.absoluteString)
                    }
                    
                }
            }
        }
        ref.downloadURL { (url, _) in
            if let urlString = url
            {
                print(urlString)
                UploadCompleten(urlString.absoluteString)
            }
        }
        
    }
    
}


