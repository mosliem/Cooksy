//
//  SignupViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/6/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit
import Firebase
class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignupButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
            navigationController?.navigationBar.isHidden = true
       }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        usernameTextField.padding()
        passwordTextField.padding()
        emailTextField.padding()
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/2
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/2
        emailTextField.layer.cornerRadius = emailTextField.frame.height/2
        SignupButton.layer.cornerRadius = SignupButton.frame.height/2
        
        //TextField Delegate
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
 
    }
    
    
    @IBAction func signupButtonPressed(_ sender: UIButton)
    {
        if let username = usernameTextField.text , let email = emailTextField.text ,let password = passwordTextField.text , !email.isEmpty, !password.isEmpty
        {
            Auth.auth().createUser(withEmail: email, password: password) { (auth, error) in
                
                if let e = error
                {
                    let alert = UIAlertController(title: "Sorry", message:e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert,animated: true)
                }
                else
                {
                    let usernameSet = Auth.auth().currentUser?.createProfileChangeRequest()
                    usernameSet?.displayName = username
                    usernameSet?.commitChanges(completion: { (error) in
                      
                        if let e = error
                        {
                          let alert = UIAlertController(title: "Sorry", message:e.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert,animated: true)
                        }
                        else
                        {
                            self.performSegue(withIdentifier: "signupToMain", sender: self)
                        }
                    })
                  
                }
            }
        }
        else
        {
         let alert = UIAlertController(title: "Sorry", message:"You Should enter these fields", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(alert,animated: true)
        }
    }
    @IBAction func signinButtonPressed(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
}


extension SignupViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
