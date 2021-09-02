//
//  LikedViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/28/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit
import Firebase
class LikedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let loadingView = UIView(frame: CGRect(x: 150, y: 390, width: 100, height: 100))
    var lovedRecipes : [lovedRecipe] = []
    let username = Auth.auth().currentUser?.displayName
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var chosenId : Int?
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        updateUI()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "lovedRecipeCell", bundle: nil), forCellReuseIdentifier:"reusableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        loadingScreen()
    }
    
    func loadingScreen()
     {
         let loadingIcon = UIActivityIndicatorView(frame: CGRect(x: -25, y: -10, width: 150, height: 150))
         loadingIcon.hidesWhenStopped = true
         loadingIcon.startAnimating()
         loadingIcon.style = .medium
         loadingView.addSubview(loadingIcon)
         self.view.addSubview(loadingView)
         updateData()
    
    }
     
    
    func updateData()
    {
        db.collection(username!).addSnapshotListener { (querySnapShot, error) in
            
            if let e = error
            {
                print(e.localizedDescription)
            }
            
            if let snapShotdoc = querySnapShot?.documents
            {
                self.lovedRecipes = []
                var index = 1
                for doc in snapShotdoc
                {
               
                    let data = doc.data()
                    if let imageURL = data["imageURL"] as? String
                    {
                        self.downloadRecImage(url: imageURL) { (image) in
                            
                            if let name = data["name"] as? String , let time = data["time"] as? Int , let serving = data["serving"] as? Int, let id = data["id"] as? String , let loved = data["loved"] as? Bool
                            {
                                let newItem = lovedRecipe(loved: loved, id: id, image: image, name: name, serving:serving, time: time)
                                self.lovedRecipes.append(newItem)
                            }
                            index += 1
                            if index == snapShotdoc.count
                            {
                                DispatchQueue.main.async {
                                self.loadingView.removeFromSuperview()
                                }
                                self.updateUI()
                            }
                        }
                    }
                    
                }
            }
        }
    }
    func updateUI()
    {
        DispatchQueue.main.async{
           self.tableView.reloadData()
        }
    }
    func downloadRecImage(url : String , downloadCompletion : @escaping (UIImage) -> Void) {
     
        let url = URL(string: url)
        let task = URLSession.shared.dataTask(with: url!){(data ,_, error) in
            
            if let e = error
            {
                print(e.localizedDescription)
            }
            else if let  imageData = data
            {
                let image = UIImage(data: imageData)
                downloadCompletion(image!)
            }
        }
        task.resume()
    }
}

extension LikedViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lovedRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = lovedRecipes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell") as! lovedRecipeCell
        cell.fetchIdDelegate = self
        cell.recipeImage.image = item.image
        cell.titleLabel.text = item.name
        cell.timeLabel.text = String("\(item.time) minutes")
        cell.servingLabel.text = String("\(item.serving) people")
        cell.id = Int(item.id)
        return cell
    }

}
 
extension LikedViewController : getCellId
{
    func fetchId(id: Int)
    {
     print(id)
      chosenId = id
      performSegue(withIdentifier: "favoritesToDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesToDetails"
        {
            let vc = segue.destination as! RecipePageViewController
            vc.id = chosenId
        }
        
    }

}

