//
//  SignUpViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var signUpTitle: UILabel!
    var nameTextField: TextField!
    var emailTextField: TextField!
    var userNameTextField: TextField!
    var passwordTextField: TextField!
    var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage() // set line below bar to blank
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func textFieldShouldReturn(_ textField: TextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? TextField {
            nextField.becomeFirstResponder() //advances to next text field when return is pressed
        } else {
            // no more text fields after, which means this is the last text field and therefore we should signup
            signUpClicked()
        }
        return false
    }
    
    
    func setUpUI() {
        setUpBackground()
        setUpSignUpTitle()
        setUpTextFields()
        setUpSignUpButton()
    }
    
    func setUpBackground() {
        self.setUpImage()
        self.setUpBlur()
    }
    
    func setUpSignUpTitle() {
        signUpTitle = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.25, width: 100, height: 30))
        signUpTitle.text = "Sign In"
        signUpTitle.font = UIFont(name: "SanFranciscoText-Regular", size: 35)
        signUpTitle.textColor = UIColor.white
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
        UITextField.appearance().tintColor = UIColor.white
    }
    
    func setUpNameTextField() {
        nameTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: signUpTitle.frame.maxY + 20, width: 250, height: 30))
        userNameTextField.textColor = UIColor.white
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        nameTextField.layer.borderColor = UIColor.white.cgColor
        nameTextField.layer.borderWidth = 0.6
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.masksToBounds = true
        nameTextField.tag = 0 //used for pressing return, advances to next text field
        view.addSubview(nameTextField)
    }
    
    func setUpEmailTextField() {
        emailTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: nameTextField.frame.maxY + 20, width: 250, height: 30))
        emailTextField.placeholder = "Email"
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 3
        emailTextField.layer.masksToBounds = true
        emailTextField.tag = 1
        view.addSubview(emailTextField)
    }
    
    func setUpUserNameTextField() {
        userNameTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: emailTextField.frame.maxY + 20, width: 250, height: 30))
        userNameTextField.placeholder = "Username"
        userNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        userNameTextField.layer.borderWidth = 0.5
        userNameTextField.layer.cornerRadius = 3
        userNameTextField.layer.masksToBounds = true
        userNameTextField.tag = 2
        view.addSubview(userNameTextField)
    }
    
    func setUpPasswordTextField() {
        passwordTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: userNameTextField.frame.maxY + 20, width: 250, height: 30))
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 3
        passwordTextField.layer.masksToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tag = 3
        passwordTextField.returnKeyType = UIReturnKeyType.go
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
            }
            else {
                self.displayErrorMessage(withError: error!)
            }
        })
    }
    func displayErrorMessage(withError error: Error) {
        let errorMessage = UILabel(frame: CGRect(x: 10, y: Int((navigationController?.navigationBar.frame.maxY)! + 10), width: Int(self.view.frame.width - 20), height: 40))
        let description = error.localizedDescription
        errorMessage.textColor = UIColor.white
        errorMessage.font = UIFont.systemFont(ofSize: 15)
        errorMessage.backgroundColor = UIColor(red: 255/255, green: 77/255, blue: 77/255, alpha: 1)
        errorMessage.textAlignment = .center
        errorMessage.layer.cornerRadius = 10
        errorMessage.clipsToBounds = true
        if description.contains("internal") {
            errorMessage.text = "Something is wrong. Try again."
        } else {
            errorMessage.text = description
        }
        self.view.addSubview(errorMessage)
    }

}
