//
//  SignupViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/6/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignupButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        usernameTextField.padding()
        passwordTextField.padding()
        emailTextField.padding()
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/2
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/2
        emailTextField.layer.cornerRadius = emailTextField.frame.height/2
        SignupButton.layer.cornerRadius = SignupButton.frame.height/2
        
 
    }
    

    @IBAction func signupButtonPressed(_ sender: UIButton)
    {
        
    }
    

}
