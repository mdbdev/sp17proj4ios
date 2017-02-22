//
//  ViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/20/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    var signUpTitle: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var userNameTextField: UITextField!
    var passwordTextField: UITextField!
    var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        setUpUI()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder() //advances to next text field when return is pressed
        } else {
            // no more text fields after, which means this is the last text field and therefore we should signup
            signUpClicked()
        }
        return false
    }
    
    
    func setUpUI() {
        setUpSignUpTitle()
        setUpTextFields()
        setUpSignUpButton()
    }
    
    func setUpSignUpTitle() {
        signUpTitle = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.2, width: 100, height: 30))
        signUpTitle.text = "MDB Socials"
        signUpTitle.font = UIFont.systemFont(ofSize: 30, weight: 2)
        signUpTitle.sizeToFit()
        signUpTitle.frame.origin.x = view.frame.width / 2 - signUpTitle.frame.width / 2
        view.addSubview(signUpTitle)
    }
    
    // implement return button!!!
    func setUpTextFields() {
        setUpNameTextField()
        setUpEmailTextField()
        setUpUserNameTextField()
        setUpPasswordTextField()
        nameTextField.delegate = self
        emailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func setUpNameTextField() {
        nameTextField = UITextField(frame: CGRect(x: view.frame.width / 2 - 125, y: signUpTitle.frame.maxY + 20, width: 250, height: 30))
        nameTextField.placeholder = "Name"
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.cornerRadius = 3
        nameTextField.layer.masksToBounds = true
        nameTextField.tag = 0 //used for pressing return, advances to next text field
        view.addSubview(nameTextField)
    }
    
    func setUpEmailTextField() {
        emailTextField = UITextField(frame: CGRect(x: view.frame.width / 2 - 125, y: nameTextField.frame.maxY + 20, width: 250, height: 30))
        emailTextField.placeholder = "Email"
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 3
        emailTextField.layer.masksToBounds = true
        emailTextField.tag = 1
        view.addSubview(emailTextField)
    }
    
    func setUpUserNameTextField() {
        userNameTextField = UITextField(frame: CGRect(x: view.frame.width / 2 - 125, y: emailTextField.frame.maxY + 20, width: 250, height: 30))
        userNameTextField.placeholder = "Username"
        userNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        userNameTextField.layer.borderWidth = 0.5
        userNameTextField.layer.cornerRadius = 3
        userNameTextField.layer.masksToBounds = true
        userNameTextField.tag = 2
        view.addSubview(userNameTextField)
    }
    
    func setUpPasswordTextField() {
        passwordTextField = UITextField(frame: CGRect(x: view.frame.width / 2 - 125, y: userNameTextField.frame.maxY + 20, width: 250, height: 30))
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 3
        passwordTextField.layer.masksToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tag = 3
        passwordTextField.returnKeyType = UIReturnKeyType.search
        passwordTextField.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        view.addSubview(passwordTextField)
    }
    
    func setUpSignUpButton() {
        signUpButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 50, y: passwordTextField.frame.maxY + 20, width: 100, height: 30))
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(UIColor.black, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        view.addSubview(signUpButton)
    }
    
    func signUpClicked() {
        let email = emailTextField.text!
        let name = nameTextField.text!
        let username = userNameTextField.text!
        let password = passwordTextField.text!
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
                ref.setValue(["name": name, "email": email, "username": username])
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
                self.userNameTextField.text = ""
//                let storage = FIRStorage.storage().reference().child("profilepics/\((FIRAuth.auth()?.currentUser?.uid)!)")
//                let metadata = FIRStorageMetadata()
//                metadata.contentType = "image/jpeg"
//                storage.put(profileImageData!, metadata: metadata).observe(.success) { (snapshot) in
//                    let url = snapshot.metadata?.downloadURL()?.absoluteString
//                    ref.setValue(["name": name, "email": email, "imageUrl": url])
//                    //self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
//                    self.emailTextField.text = ""
//                    self.passwordTextField.text = ""
//                    self.nameTextField.text = ""
//                    self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
//                    
//                }
                self.performSegue(withIdentifier: "toFeed", sender: self)
            }
            else {
                self.displayErrorMessage(withError: error!)
            }
        })
    }
}

extension UIViewController {
    
    func displayErrorMessage(withError error: Error) {
        let errorMessage = UILabel(frame: CGRect(x: 5, y: UIApplication.shared.statusBarFrame.maxY, width: self.view.frame.width - 10, height: 50))
        let description = error.localizedDescription
        errorMessage.backgroundColor = UIColor.red
        errorMessage.adjustsFontSizeToFitWidth = true
        errorMessage.textAlignment = .center
        if description.contains("internal") {
            errorMessage.text = "Something went wrong. Try again."
        } else {
            errorMessage.text = description
        }
        self.view.addSubview(errorMessage)
    }
}

