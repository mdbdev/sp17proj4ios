//
//  SignUpViewController.swift
//  MDBSocial
//
//  Created by Levi Walsh on 2/22/17.
//  Copyright © 2017 Levi Walsh. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var emailTextField: UITextField!
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var nameTextField: UITextField!
    var profileImageView: UIImageView!
    var signupButton: UIButton!
    var goBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        view.addSubview(profileImageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupTextFields() {
        nameTextField = UITextField(frame: CGRect(x: 10, y: 0.5 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 30))
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.placeholder = "Full Name"
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.masksToBounds = true
        nameTextField.textColor = UIColor.black
        self.view.addSubview(nameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: 10, y: 0.5 * UIScreen.main.bounds.height + 40, width: UIScreen.main.bounds.width - 20, height: 30))
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.placeholder = "Email"
        emailTextField.layoutIfNeeded()
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = UIColor.black
        self.view.addSubview(emailTextField)
        
        usernameTextField = UITextField(frame: CGRect(x: 10, y: 0.5 * UIScreen.main.bounds.height + 80, width: UIScreen.main.bounds.width - 20, height: 30))
        usernameTextField.adjustsFontSizeToFitWidth = true
        usernameTextField.placeholder = "Username"
        usernameTextField.layoutIfNeeded()
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.masksToBounds = true
        usernameTextField.textColor = UIColor.black
        self.view.addSubview(usernameTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 10, y: 0.5 * UIScreen.main.bounds.height + 120, width: UIScreen.main.bounds.width - 20, height: 30))
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = UIColor.black
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
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
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
                ref.setValue(["name": name, "email": email])
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
                self.performSegue(withIdentifier: "SignupToFeed", sender: self)
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
