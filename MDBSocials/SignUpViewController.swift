//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by Sahil Lamba on 2/12/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var nameTextField: UITextField!
    var profileImageView: UIImageView!
    var signupButton: UIButton!
    var goBackButton: UIButton!
    var selectFromLibraryButton: UIButton!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
        setupTextFields()
        setupButtons()
        setupProfileImageView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfileImageView() {
        profileImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40))
        selectFromLibraryButton = UIButton(frame: profileImageView.frame)
        selectFromLibraryButton.setTitle("Pick Image From Library", for: .normal)
        selectFromLibraryButton.setTitleColor(UIColor.blue, for: .normal)
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        view.addSubview(profileImageView)
        view.addSubview(selectFromLibraryButton)
        view.bringSubview(toFront: selectFromLibraryButton)
        
    }
    
    func pickImage(sender: UIButton!) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupTextFields() {
        emailTextField = UITextField(frame: CGRect(x: 10, y: 0.6 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 30))
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.placeholder = "Email"
        emailTextField.layoutIfNeeded()
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = UIColor.black
        self.view.addSubview(emailTextField)
        
        
        passwordTextField = UITextField(frame: CGRect(x: 10, y: 0.6 * UIScreen.main.bounds.height + 40, width: UIScreen.main.bounds.width - 20, height: 30))
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = UIColor.black
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
        
        nameTextField = UITextField(frame: CGRect(x: 10, y: 0.6 * UIScreen.main.bounds.height + 80, width: UIScreen.main.bounds.width - 20, height: 30))
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.placeholder = "Name"
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.masksToBounds = true
        nameTextField.textColor = UIColor.black
        self.view.addSubview(nameTextField)
    }
    
    func setupButtons() {
        
        signupButton = UIButton(frame: CGRect(x: 10, y: 0.8 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 30))
        signupButton.layoutIfNeeded()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(UIColor.blue, for: .normal)
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.cornerRadius = 3.0
        signupButton.layer.borderColor = UIColor.blue.cgColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
        self.view.addSubview(signupButton)
        
        goBackButton = UIButton(frame: CGRect(x: 10, y: 0.8 * UIScreen.main.bounds.height + 40, width: UIScreen.main.bounds.width - 20, height: 30))
        goBackButton.layoutIfNeeded()
        goBackButton.setTitle("Go Back", for: .normal)
        goBackButton.setTitleColor(UIColor.blue, for: .normal)
        goBackButton.layer.borderWidth = 2.0
        goBackButton.layer.cornerRadius = 3.0
        goBackButton.layer.borderColor = UIColor.blue.cgColor
        goBackButton.layer.masksToBounds = true
        goBackButton.addTarget(self, action: #selector(goBackButtonClicked), for: .touchUpInside)
        self.view.addSubview(goBackButton)
        
    }
    
    
    func signupButtonClicked() {
        let profileImageData = UIImageJPEGRepresentation(profileImageView.image!, 0.9)
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
                let storage = FIRStorage.storage().reference().child("profilepics/\((FIRAuth.auth()?.currentUser?.uid)!)")
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                storage.put(profileImageData!, metadata: metadata).observe(.success) { (snapshot) in
                    let url = snapshot.metadata?.downloadURL()?.absoluteString
                    ref.setValue(["name": name, "email": email, "imageUrl": url])
                    //self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.nameTextField.text = ""
                    self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
                }
                    
            }
            else {
                print(error.debugDescription)
            }
        })
    }
    
    func goBackButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectFromLibraryButton.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

