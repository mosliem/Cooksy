//
//  EditProfileViewController.swift
//  Cooksy
//
//  Created by mohamedSliem on 8/10/21.
//  Copyright © 2021 mohamedSliem. All rights reserved.
//

import UIKit
import Firebase

protocol updateInfoDelegate
{
    func updateInfo(date :String , gender : String , phoneNO : String , profilePicUrl : String)
}


class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let storage = Storage.storage().reference()
    let datePicker = UIDatePicker()
    let db = Firestore.firestore()
    var profilePicUrl : String?
    var chosenImage : UIImage?
    var Lastusername : String?
    var Lastgender : String?
    var LastphoneNO : String?
    var Lastdate : String?
    var LastprofilePic : UIImage?
    var LastPhotoUrl : String?
    
    var updateDelegate : updateInfoDelegate!
    
    private let progressView : UIProgressView = {
       let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .blue
        return progressView
    }()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Rounded icons and textfields
        profilePic.makeRounded()
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/2
        genderTextField.layer.cornerRadius = usernameTextField.frame.height/2
        dateOfBirthTextField.layer.cornerRadius = usernameTextField.frame.height/2
        phoneNoTextField.layer.cornerRadius = usernameTextField.frame.height/2
        saveButton.layer.cornerRadius = usernameTextField.frame.height/2
        
        //text padding
        phoneNoTextField.padding()
        genderTextField.padding()
        usernameTextField.padding()
        dateOfBirthTextField.padding()
        createDatePicker()
        //set the latest user info
        usernameTextField.text = Lastusername
        genderTextField
            .text = Lastgender
        phoneNoTextField.text = LastphoneNO
        dateOfBirthTextField.text = Lastdate
        
        
        //set the lastest image the profile pic image view
        profilePic.image = LastprofilePic
    }
    
    
    func createDatePicker()
    {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target:nil , action: #selector(doneBtnPressed))
        
        toolbar.setItems([doneBtn], animated: true)
        dateOfBirthTextField.inputAccessoryView = toolbar
        dateOfBirthTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func doneBtnPressed()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        dateOfBirthTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton)
    {
        storeImage()
        //storeImage -> createProgressBarAlert -> SaveAlert (delegate)
      
    }
    
    // function to upload images and get URL for it
    // call the delegation function saveChanges to send the changed data and update it in the database
    func storeImage()
    {
        print("stored")
        // if there is a chosen image to set it
        if chosenImage != nil
        {
            guard let imageData = chosenImage!.pngData() else {
                return
            }
            
            let alert =  self.createProgressBarAlet()
            let ref = storage.child("ProfilesImages/\(Lastusername!)")
            let uploadTask = ref.putData(imageData, metadata:nil) { (_, error) in
                if let e = error
                {
                    let alert = UIAlertController(title: "Sorry", message:e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert,animated: true)
                }
                
                print("created")
                ref.downloadURL { (url, error) in
                    if let e = error
                    {
                        print("Ferror")
                        print(e.localizedDescription)
                    }
                    else
                    {
                        print("Url Setted")
                        self.profilePicUrl = url?.absoluteString
                        alert.dismiss(animated: true, completion: nil)
                        self.saveChanges()
                    }
                    
                }
            }
            
            // observer to follow up with uploading progress
            uploadTask.observe(.progress) { (snapshot) in
                let progress = Float(snapshot.progress!.fractionCompleted)
                print(progress)
                DispatchQueue.main.async
                    {
                        self.progressView.setProgress(progress, animated: true)
                    }
                
               }
        }
        else  //if there is no choseimage to set it
        {
            saveChanges()
        }
    }
    
    // confirm the delegation operation
    func saveChanges()
    {
        print("saved")
        let date = dateOfBirthTextField.text ?? Lastdate
        let phoneNO = phoneNoTextField.text ?? LastphoneNO
        let gender = genderTextField.text ?? Lastgender
        profilePicUrl = profilePicUrl ?? LastPhotoUrl
        
        
        self.updateDelegate?.updateInfo(date: date! , gender: gender!, phoneNO: phoneNO!, profilePicUrl: self.profilePicUrl!)
        self.navigationController?.popViewController(animated: true)
    }
    
    // creating An alert with progress bar to follow up with uploading of images
    func  createProgressBarAlet() -> UIAlertController
    {
        let alert = UIAlertController(title: "Uploading", message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        self.present(alert,animated: true,completion: {
            let margin:CGFloat = 8.0
            let rect = CGRect(x: margin, y: 50.0, width: alert.view.frame.width - margin * 2.0 , height: 2.0)
            self.progressView.frame = rect
            alert.view.addSubview(self.progressView)
        })
        
        return alert
    }
  
}

extension EditProfileViewController : UIImagePickerControllerDelegate ,UINavigationControllerDelegate
{
    @IBAction func changePictureButtonPressed(_ sender: UIBarButtonItem)
    {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        //choose an image from photos with the ability of editing it
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else
        {
            return
        }
        chosenImage = image
        profilePic.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
} 

// rounded image view
// to get a circular shape, image view width and hieght must be even
extension UIImageView
{
    func makeRounded() {
        
        self.layer.borderWidth = 1
        self.contentMode = .scaleAspectFill
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
