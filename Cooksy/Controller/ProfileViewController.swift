
import UIKit
import Firebase
class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var GenderTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNOTextField: UITextField!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var profilePic: UIImageView!
    let db = Firestore.firestore()
    var photoUrl: String?
    var image : UIImage = UIImage(named: "MeAvatar")!
    
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/2
        GenderTextField.layer.cornerRadius = usernameTextField.frame.height/2
        dateOfBirthTextField.layer.cornerRadius = usernameTextField.frame.height/2
        phoneNOTextField.layer.cornerRadius = usernameTextField.frame.height/2
        editProfileButton.layer.cornerRadius = usernameTextField.frame.height/2
        profilePic.makeRounded()
        phoneNOTextField.padding()
        GenderTextField.padding()
        usernameTextField.padding()
        dateOfBirthTextField.padding()
        getUserInf()
        
    }

    func getUserInf()
    {
        print("Uiupdated")
        let userAuth = Auth.auth().currentUser
        usernameTextField.text = userAuth?.displayName
        db.collection((userAuth?.displayName)!).document("user info").addSnapshotListener( {(docSnapshot, error) in
            if let doc = docSnapshot, doc.exists
            {
                print("dataTriggered")
                let info = doc.data()
                DispatchQueue.main.async
                    {
                        self.GenderTextField.text = info!["gender"] as? String
                        self.dateOfBirthTextField.text = info!["dateOfBirth"] as? String
                        self.phoneNOTextField.text = info!["phoneNO"] as? String
                        self.photoUrl = info!["profilePicUrl"] as?String
                        print(self.photoUrl!)
                        self.profilePic.image = self.downloadProfilePic(url: self.photoUrl!)
                        
                }
                
                
            }
            
        })
        
    }
    

    
    @IBAction func editProfileButtonPressed(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "myprofileToEdit", sender: self)
     
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let username = Auth.auth().currentUser?.displayName
        let gender = GenderTextField.text ?? "Not Specified"
        let phoneNo = phoneNOTextField.text ?? "Not Specified"
        let date = dateOfBirthTextField.text ?? "Not Specified"
        if segue.identifier == "myprofileToEdit"
        {
            let destinationVC = segue.destination as! EditProfileViewController
            destinationVC.Lastusername = username
            destinationVC.Lastgender = gender
            destinationVC.LastphoneNO = phoneNo
            destinationVC.Lastdate = date
            destinationVC.LastPhotoUrl = photoUrl
            destinationVC.LastprofilePic = image
            destinationVC.updateDelegate = self
        }
    }
        func downloadProfilePic(url : String) -> UIImage
        {
            print(url)
                let photoUrl = URL(string: url)!
                let task =  URLSession.shared.dataTask(with: photoUrl) { (data, _ , error) in
                    
                    if let e = error
                    {
                        print(e)
                    }
                    if let data = data
                    {
                        DispatchQueue.main.async
                            {
                                self.image = UIImage(data: data)!
                                self.profilePic.image = self.image
                        }
                    }
                }
                task.resume()
            
            return image
        }
    }



extension ProfileViewController : updateInfoDelegate
{
    func updateInfo(date: String, gender: String, phoneNO : String, profilePicUrl : String)
    {
      print("delegate")
        db.collection((Auth.auth().currentUser?.displayName)!).document("user info").updateData([
            "dateOfBirth" : date,
            "gender" : gender,
            "phoneNO" : phoneNO,
            "profilePicUrl" : profilePicUrl
            ])
        { (error) in
            if let e = error
            {
                print(e.localizedDescription)
            }
        }

    }
    
    
}
