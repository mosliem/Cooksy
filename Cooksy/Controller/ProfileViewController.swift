
import UIKit
import Firebase
class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var GenderTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNOTextField: UITextField!
    @IBOutlet weak var editProfileButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/2
        GenderTextField.layer.cornerRadius = usernameTextField.frame.height/2
        dateOfBirthTextField.layer.cornerRadius = usernameTextField.frame.height/2
        phoneNOTextField.layer.cornerRadius = usernameTextField.frame.height/2
        editProfileButton.layer.cornerRadius = usernameTextField.frame.height/2
        
        phoneNOTextField.padding()
        GenderTextField.padding()
        usernameTextField.padding()
        dateOfBirthTextField.padding()
        
        getUserInf()
    }

    func getUserInf()
    {
        
        let userAuth = Auth.auth().currentUser
        usernameTextField.text = userAuth?.displayName
        db.collection((userAuth?.displayName)!).document("user info").getDocument { (docSnapshot, error) in
            if let doc = docSnapshot, doc.exists
            {
                let info = doc.data()
                self.GenderTextField.text = info!["gender"] as? String
                self.dateOfBirthTextField.text = info!["dateOfBirth"] as? String
                self.phoneNOTextField.text = info!["phoneNO."] as? String
              
            }
    
        }
            
     }
    
    @IBAction func editProfileButtonPressed(_ sender: UIButton)
    {
         performSegue(withIdentifier: "myprofileToEdit", sender: self)
    }
    
  }

