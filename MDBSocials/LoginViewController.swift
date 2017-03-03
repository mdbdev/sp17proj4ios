//
//  LoginViewController.swift
//  MDBSocials
//
//  Created by Amy on 2/21/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginViewController: UIViewController {
    
    var appTitle1: UILabel!
    var appTitle2: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var circle1: UIImageView!
    var circle2: UIImageView!
    var circle3: UIImageView!
    var loginButton: UIButton!
    var signupButton: UIButton!
    var politeSignupText: UILabel!
    var background: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUpBackground()
        setupTitle()
        setupTextFields()
        setupButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    func setUpBackground() {
        
        //sets up gradient background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "turquoiseBackground")?.draw(in: self.view.bounds)
        
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        } else {
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
        //set up first circle
        circle1 = UIImageView(frame: CGRect(x: 155, y: 255, width: 12, height: 12))
        circle1.backgroundColor = UIColor.white
        circle1.layer.cornerRadius = circle1.frame.size.width / 2;
        circle1.clipsToBounds = true;
        
        //set up second circle
        circle2 = UIImageView(frame: CGRect(x: 130, y: 275, width: 25, height: 25))
        circle2.backgroundColor = UIColor.white
        circle2.layer.cornerRadius = circle2.frame.size.width / 2;
        circle2.clipsToBounds = true;
        
        //set up third circle
        circle3 = UIImageView(frame: CGRect(x: 75, y: 320, width: 270, height: 200))
        circle3.backgroundColor = UIColor.white
        circle3.layer.cornerRadius = 30
        circle3.clipsToBounds = true;
        
        self.view.addSubview(circle1)
        self.view.addSubview(circle2)
        self.view.addSubview(circle3)
        
    }
    func setupTitle() {
        appTitle1 = UILabel(frame: CGRect(x: 103, y: 100, width: UIScreen.main.bounds.width - 20, height: 0.3 * UIScreen.main.bounds.height))
        appTitle1.text = "mdb"
        appTitle1.font = UIFont(name: "AvenirNext-Bold", size: 85)
        appTitle1.textColor = UIColor.white
        appTitle2 = UILabel(frame: CGRect(x: 205, y: 144, width: UIScreen.main.bounds.width - 20, height: 0.3 * UIScreen.main.bounds.height))
        appTitle2.text = "socials"
        appTitle2.font = UIFont(name: "Goodfish-Italic", size: 50)
        appTitle2.textColor = UIColor.white
        view.addSubview(appTitle1)
        view.addSubview(appTitle2)
    }
    
    func setupTextFields() {
        
        //set up email field
        emailTextField = UITextField(frame: CGRect(x: 97, y: 350, width: 227, height: 30))
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.placeholder = " Enter your email"
        emailTextField.layoutIfNeeded()
        emailTextField.layer.borderColor = Constants.aqua.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = UIColor.black
        
        //set up password field
        passwordTextField = UITextField(frame: CGRect(x: 97, y: 390, width: 227, height: 30))
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.placeholder = " Password"
        passwordTextField.layer.borderColor = Constants.aqua.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = UIColor.black
        passwordTextField.isSecureTextEntry = true
        
        //set up polite signup field
        politeSignupText = UILabel(frame: CGRect(x: 180, y: 489, width: 120, height: 30))
        politeSignupText.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        politeSignupText.text = "No account?"
        politeSignupText.textColor = UIColor.black
        
        self.view.addSubview(politeSignupText)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
    }
    
    func setupButtons() {
        
        loginButton = UIButton(frame: CGRect(x: 97, y: 440, width: 227, height: 30))
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = Constants.aqua
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
        signupButton = UIButton(frame: CGRect(x: 260, y: 489, width: 60, height: 30))
        signupButton.setTitle("Sign up!", for: .normal)
        signupButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        signupButton.setTitleColor(UIColor.init(red: 0, green: 0.7, blue: 0.7, alpha: 1), for: .normal)
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.cornerRadius = 3.0
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(loginButton)
        self.view.addSubview(signupButton)
    }
    
    func loginButtonClicked(sender: UIButton!) {
        // performs login
        let email = emailTextField.text!
        let password = passwordTextField.text!
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                self.performSegue(withIdentifier: "toFeedFromLogin", sender: self)
            }
            
        })
    }
    
    
    func signupButtonClicked(sender: UIButton!) {
        performSegue(withIdentifier: "toSignup", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


