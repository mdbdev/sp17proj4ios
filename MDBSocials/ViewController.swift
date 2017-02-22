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

    var loginTitle: UILabel!
    var userNameTextField: TextField!
    var passwordTextField: TextField!
    var loginButton: UIButton!
    var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder() //advances to next text field when return is pressed
        } else {
            // no more text fields after, which means this is the last text field and therefore we should signup
            loginClicked()
        }
        return false
    }
    
    
    func setUpUI() {
        setUpBackground()
        setUpLoginTitle()
        setUpTextFields()
        setUpLoginButton()
        setUpSignUpButton()
    }
    
    func setUpBackground() {
        self.setUpImage()
        self.setUpBlur()
    }
    
    
    func setUpLoginTitle() {
        loginTitle = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.25, width: 100, height: 30))
        loginTitle.text = "Log In"
        loginTitle.font = UIFont(name: "SanFranciscoText-Regular", size: 35)
        loginTitle.textColor = UIColor.white
        loginTitle.sizeToFit()
        loginTitle.frame.origin.x = view.frame.width / 2 - loginTitle.frame.width / 2
        view.addSubview(loginTitle)
    }
    
    // implement return button!!!
    func setUpTextFields() {
        setUpUserNameTextField()
        setUpPasswordTextField()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        UITextField.appearance().tintColor = UIColor.white
    }
    
    
    func setUpUserNameTextField() {
        userNameTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: loginTitle.frame.maxY + 20, width: 250, height: 40))
        userNameTextField.textColor = UIColor.white
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        userNameTextField.layer.borderColor = UIColor.white.cgColor
        userNameTextField.layer.borderWidth = 0.6
        userNameTextField.layer.cornerRadius = 10
        userNameTextField.layer.masksToBounds = true
        userNameTextField.tag = 0
        view.addSubview(userNameTextField)
    }
    
    func setUpPasswordTextField() {
        passwordTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: userNameTextField.frame.maxY + 20, width: 250, height: 40))
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 0.6
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.masksToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tag = 1
        passwordTextField.returnKeyType = UIReturnKeyType.go
        passwordTextField.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        view.addSubview(passwordTextField)
    }
    
    func setUpLoginButton() {
        loginButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 125, y: passwordTextField.frame.maxY + 20, width: passwordTextField.frame.width, height: 40))
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "SanFranciscoText-Regular", size: 17)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor(red: 0, green: 204/255, blue: 68/255, alpha: 1)
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
    func loginClicked() {
//        let username = userNameTextField.text!
//        let password = passwordTextField.text!
//        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
//            if error == nil {
//                let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
//                ref.setValue(["name": name, "email": email, "username": username])
//                self.emailTextField.text = ""
//                self.passwordTextField.text = ""
//                self.nameTextField.text = ""
//                self.userNameTextField.text = ""
////                let storage = FIRStorage.storage().reference().child("profilepics/\((FIRAuth.auth()?.currentUser?.uid)!)")
////                let metadata = FIRStorageMetadata()
////                metadata.contentType = "image/jpeg"
////                storage.put(profileImageData!, metadata: metadata).observe(.success) { (snapshot) in
////                    let url = snapshot.metadata?.downloadURL()?.absoluteString
////                    ref.setValue(["name": name, "email": email, "imageUrl": url])
////                    //self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
////                    self.emailTextField.text = ""
////                    self.passwordTextField.text = ""
////                    self.nameTextField.text = ""
////                    self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
////                    
////                }
//            }
//            else {
//                self.displayErrorMessage(withError: error!)
//            }
//        })
        
    }
    
    func displayErrorMessage(withError error: Error) {
        let errorMessage = UILabel(frame: CGRect(x: 10, y: Int(UIApplication.shared.statusBarFrame.maxY + 5), width: Int(self.view.frame.width - 20), height: 40))
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
    
    func setUpSignUpButton() {
        signUpButton = UIButton(frame: CGRect(x: view.frame.width / 2, y: loginButton.frame.maxY + 10, width: 60, height: 40))
        signUpButton.setTitle("Create An Account", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "SanFranciscoText-Regular", size: 17)
        signUpButton.sizeToFit()
        signUpButton.frame.origin.x = view.frame.width / 2 - signUpButton.frame.width / 2
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        view.addSubview(signUpButton)
    }
    
    func signUpClicked() {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
}

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpImage() {
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.image = #imageLiteral(resourceName: "mdb")
        view.addSubview(backgroundImage)
    }
    
    func setUpBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}

