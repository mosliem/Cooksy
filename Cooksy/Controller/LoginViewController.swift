//
//  LoginViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/6/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var signinButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailTextField.layer.cornerRadius = emailTextField.frame.height/2
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/2
        signinButton.layer.cornerRadius = signinButton.frame.height/2
        emailTextField.padding()
        passwordTextField.padding()
        
        // textField Delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
       
    
    @IBAction func signinButtonPressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "loginToMain", sender: self)
    }
    
    
    @IBAction func SignupButtonPressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "loginToSignup", sender: self)
    }

}

// extention with padding function to set a space at the right and the left of a Textfield
extension UITextField
{
    func padding()
    {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width:20, height: self.frame.height))
    self.leftView = paddingView
    self.rightView = paddingView
    self.leftViewMode = UITextField.ViewMode.always
    self.rightViewMode = UITextField.ViewMode.always
    }
}

extension LoginViewController : UITextFieldDelegate
{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.endEditing(true)
        return true
    }
}
