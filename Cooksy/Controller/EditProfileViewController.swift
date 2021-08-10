//
//  EditProfileViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/10/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/2
        genderTextField.layer.cornerRadius = usernameTextField.frame.height/2
        dateOfBirthTextField.layer.cornerRadius = usernameTextField.frame.height/2
        phoneNoTextField.layer.cornerRadius = usernameTextField.frame.height/2
        saveButton.layer.cornerRadius = usernameTextField.frame.height/2
        
        phoneNoTextField.padding()
        genderTextField.padding()
        usernameTextField.padding()
        dateOfBirthTextField.padding()

    }
    
}
