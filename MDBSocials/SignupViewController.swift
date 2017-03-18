//
//  SignupViewController.swift
//  MDBSocials
//
//  Created by Amy on 2/21/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SignUpViewController: UIViewController {
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var nameTextField: UITextField!
    var userNameTextField: UITextField!
    static var profileImageView: UIImageView!
    var signupButton: UIButton!
    var goBackButton: UIButton!
    var selectFromLibraryButton: UIButton!
    var cameraImage: UIImageView!
    var textBackground: UIImageView!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setupBackground()
        setupProfileImageView()
        setupTextBackground()
        setupTextFields()
        setupButtons()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBackground() {
        
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
        
    }
    
    func setupProfileImageView() {
        
        SignUpViewController.profileImageView = UIImageView(frame: CGRect(x: 50, y: 60, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100))
        SignUpViewController.profileImageView.layer.borderColor = UIColor.gray.cgColor
        SignUpViewController.profileImageView.image = UIImage(named: "anon.jpg")
        
        cameraImage = UIImageView(frame: CGRect(x: view.frame.width/2 - 40, y: view.frame.height/2 - 240, width: 80, height: 80))
        cameraImage.image = UIImage(named: "camera.jpg")
       
        selectFromLibraryButton = MDBSocialsUtils.createButton(frame: CGRect(x: 55, y: 75, width: 305, height: 400))
        selectFromLibraryButton.setTitle("Choose your profile photo", for: .normal)
        selectFromLibraryButton.titleLabel?.numberOfLines = 2
        selectFromLibraryButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 35)
        selectFromLibraryButton.setTitleColor(UIColor.white, for: .normal)
        selectFromLibraryButton.titleLabel?.textAlignment = .center
       
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
        
        view.addSubview(SignUpViewController.profileImageView)
        view.addSubview(selectFromLibraryButton)
        view.addSubview(cameraImage)
        view.bringSubview(toFront: selectFromLibraryButton)
        
    }
    func setupTextBackground() {
        
        textBackground = UIImageView(frame: CGRect(x: 35, y: 390, width: 340, height: 300))
        textBackground.backgroundColor = UIColor.white
        textBackground.layer.cornerRadius = 30
        textBackground.clipsToBounds = true;
        
        view.addSubview(textBackground)
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
        // sets up email, username, password, and full name text fields
        
        emailTextField = UITextField(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height - 30, width: UIScreen.main.bounds.width - 110, height: 30))
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.placeholder = " Email"
        emailTextField.layer.borderColor = UIColor.init(red: 0, green: 0.9, blue: 0.9, alpha: 1).cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = UIColor.black
        self.view.addSubview(emailTextField)
        
        
        passwordTextField = UITextField(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 12, width: UIScreen.main.bounds.width - 110, height: 30))
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.placeholder = " Password"
        passwordTextField.layer.borderColor = Constants.aqua.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = UIColor.black
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
        
        nameTextField = UITextField(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 54, width: UIScreen.main.bounds.width - 110, height: 30))
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.placeholder = " Name"
        nameTextField.layer.borderColor = Constants.aqua.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.masksToBounds = true
        nameTextField.textColor = UIColor.black
        self.view.addSubview(nameTextField)
        
        userNameTextField = UITextField(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 96, width: UIScreen.main.bounds.width - 110, height: 30))
        userNameTextField.adjustsFontSizeToFitWidth = true
        userNameTextField.placeholder = " Username"
        userNameTextField.layer.borderColor = Constants.aqua.cgColor
        userNameTextField.layer.borderWidth = 1.0
        userNameTextField.layer.masksToBounds = true
        userNameTextField.textColor = UIColor.black
        self.view.addSubview(userNameTextField)
    }
    
    func setupButtons() {
        
        signupButton = UIButton(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 140, width: UIScreen.main.bounds.width - 110, height: 35))
        signupButton.setTitle("Sign up!", for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.backgroundColor = Constants.aqua
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
        self.view.addSubview(signupButton)
        
        goBackButton = UIButton(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 187, width: UIScreen.main.bounds.width - 110, height: 35))
        goBackButton.layoutIfNeeded()
        goBackButton.setTitle("Cancel", for: .normal)
        goBackButton.setTitleColor(UIColor.white, for: .normal)
        goBackButton.backgroundColor = Constants.aqua
        goBackButton.addTarget(self, action: #selector(goBackButtonClicked), for: .touchUpInside)
        self.view.addSubview(goBackButton)
        
    }
    
    
    func signupButtonClicked() {
        let profileImageData = UIImageJPEGRepresentation(SignUpViewController.profileImageView.image!, 0.9)
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let userName = userNameTextField.text!
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
                let storage = FIRStorage.storage().reference().child("profilepics/\((FIRAuth.auth()?.currentUser?.uid)!)")
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                storage.put(profileImageData!, metadata: metadata).observe(.success) { (snapshot) in
                    let url = snapshot.metadata?.downloadURL()?.absoluteString
                    ref.setValue(["name": name, "email": email, "imageUrl": url, "userName" : userName])
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.nameTextField.text = ""
                    self.userNameTextField.text = ""
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
        cameraImage.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        SignUpViewController.profileImageView.contentMode = .scaleAspectFit
        SignUpViewController.profileImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

