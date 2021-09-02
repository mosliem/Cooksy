//
//  MainViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/7/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit
import Firebase
class MainViewController: UIViewController , getRandomRecipes {
   
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let loadingView = UIView(frame: CGRect(x: 150, y: 390, width: 100, height: 100))
    
    
    let db = Firestore.firestore()
    let randomRecipeManger = randomRecipesManger()
    var items : [randomRecipeModel] = []
    var selectedCellId  : Int?
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomRecipeManger.getRandomRecipeDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        ProfileImageView.makeRounded()
        getProfilePic()
        randomRecipeManger.fetchRecipes()
        loadingScreen()
        //self.view.backgroundColor = .systemGroupedBackground
        usernameLabel.text = Auth.auth().currentUser?.displayName!
        tableView.register(UINib(nibName: "lovedRecipeCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
    }
    func loadingScreen()
    {
        let loadingIcon = UIActivityIndicatorView(frame: CGRect(x: -25, y: -25, width: 150, height: 150))
        loadingIcon.hidesWhenStopped = true
        loadingIcon.startAnimating()
        loadingView.addSubview(loadingIcon)
        self.view.addSubview(loadingView)
    }
    @IBAction func logoutPressed(_ sender: UIButton)
    {
        do
        {
            print("signOut")
            
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyBoard.instantiateViewController(identifier: "rootVC") as!IntroViewController
            tabBarController?.dismiss(animated: true, completion: nil)
            tabBarController?.show(rootVC, sender: self)
            try Auth.auth().signOut()

         }
        catch let signOutError as NSError
        {
            print(signOutError)
        }
    }
    
    func getProfilePic()
    {
        print("profile called")
        db.collection((Auth.auth().currentUser?.displayName!)!).document("user info").addSnapshotListener { (snapshot, _) in
            
            if let doc = snapshot
            {
                if let imageUrl = doc["profilePicUrl"] as? String
                {
                    let url = URL(string: imageUrl)
                    let task = URLSession.shared.dataTask(with: url!){(data,_,error) in
                        if let e = error
                        {
                            print(e.localizedDescription)
                        }
                        if let safeData = data
                        {
                            DispatchQueue.main.async
                                {
                                    self.ProfileImageView.image = UIImage(data: safeData)
                            }
                        }
                        
                    }
                    task.resume()
                }
            }
        }
    }
    
    
    
    func didUpdateData(recipes: [randomRecipeModel])
    {
        print(recipes.count)
         items = recipes
        print("\(items.count) h5h")
        DispatchQueue.main.async {
            self.loadingView.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
    
}


extension MainViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! lovedRecipeCell
        cell.fetchIdDelegate = self
        cell.id = items[index].id
        cell.recipeImage.image = items[index].image
        cell.titleLabel.text = items[index].title
        cell.servingLabel.text = String(items[index].serving)
        cell.timeLabel.text = String( items[index].readyInMin)
        return cell
    }
    
    
}


extension MainViewController : getCellId
{
    func fetchId(id: Int)
    {
        selectedCellId = id
        performSegue(withIdentifier: "mainToDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToDetails"
        {
            let vc = segue.destination as! RecipePageViewController
            vc.id = selectedCellId
        }
    }
    
}
