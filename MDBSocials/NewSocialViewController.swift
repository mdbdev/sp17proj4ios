//
//  NewSocialViewController.swift
//  MDBSocials
//
//  Created by Amy on 2/21/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class NewSocialViewController: UIViewController {
    
    var eventNameTextField: UITextField!
    var descriptionTextField: UITextField!
    var dateTextField: UITextField!
    var cameraImage: UIImageView!
    var cameraImage2: UIImageView!
    var takeFromCamera: UIButton!
    var createSocial: UIButton!
    var goBackButton: UIButton!
    var selectFromLibraryButton: UIButton!
    let picker = UIImagePickerController()
    var newPostView: UITextField!
    var postButton: UIButton!
    var postCollectionView: UICollectionView!
    var posts: [Social] = []
    var auth = FIRAuth.auth()
    var users: [User] = []
    var currentUser: User!
    var textBackground: UIImageView!
    var noOne: [User] = []
    var newEventName: UITextField!
    var eventImageView: UIImageView!
    var interestedUsers: [String] = []
    var lineImage: UIImageView!
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupBackground()
        fetchUser {
            self.setupEventImageView()
            self.setupTextBackground()
            self.picker.delegate = self
            self.setupTextFields()
            self.setupButtons()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    func setupEventImageView() {
        
        eventImageView = UIImageView(frame: CGRect(x: 50, y: 90, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100))
        eventImageView.layer.borderColor = UIColor.gray.cgColor
        eventImageView.image = UIImage(named: "questionMark.jpg")
        
        cameraImage = UIImageView(frame: CGRect(x: view.frame.width/2 - 28, y: view.frame.height/2 - 100, width: 60, height: 60))
        cameraImage2 = UIImageView(frame: CGRect(x: view.frame.width/2 - 28, y: view.frame.height/2 - 250, width: 60, height: 60))
        cameraImage.image = UIImage(named: "camera.jpg")
        cameraImage2.image = UIImage(named: "camera.jpg")

        lineImage = UIImageView(frame: CGRect(x: 38, y: 20, width: 337, height: 460))
        lineImage.image = UIImage(named: "line.png")
        
        takeFromCamera = UIButton(frame: CGRect(x: 53, y: 127, width: 305, height: 170))
        takeFromCamera.setTitle("Take your event photo", for: .normal)
        takeFromCamera.titleLabel?.numberOfLines = 2
        takeFromCamera.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
        takeFromCamera.setTitleColor(UIColor.white, for: .normal)
        takeFromCamera.titleLabel?.textAlignment = .center
        takeFromCamera.addTarget(self, action: #selector(takeImage), for: .touchUpInside)
        
        selectFromLibraryButton = UIButton(frame: CGRect(x: 53, y: 269, width: 305, height: 170))
        selectFromLibraryButton.setTitle("Choose your event photo", for: .normal)
        selectFromLibraryButton.titleLabel?.numberOfLines = 2
        selectFromLibraryButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
        selectFromLibraryButton.setTitleColor(UIColor.white, for: .normal)
        selectFromLibraryButton.titleLabel?.textAlignment = .center
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
        view.addSubview(eventImageView)
        view.addSubview(takeFromCamera)
        view.addSubview(lineImage)
        view.addSubview(selectFromLibraryButton)
        view.addSubview(cameraImage)
        view.addSubview(cameraImage2)
        view.bringSubview(toFront: selectFromLibraryButton)
        
    }

    func setupTextBackground() {
        
        textBackground = UIImageView(frame: CGRect(x: 35, y: 420, width: 340, height: 300))
        textBackground.backgroundColor = UIColor.white
        textBackground.layer.cornerRadius = 30
        textBackground.clipsToBounds = true;
        
        view.addSubview(textBackground)
    }
    
    func setupTextFields() {
        
        // sets up event name, description, and date text fields
        eventNameTextField = UITextField(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 110, height: 30))
        eventNameTextField.adjustsFontSizeToFitWidth = true
        eventNameTextField.placeholder = " Event name"
        eventNameTextField.layer.borderColor = Constants.aqua.cgColor
        eventNameTextField.layer.borderWidth = 1.0
        eventNameTextField.layer.masksToBounds = true
        eventNameTextField.textColor = UIColor.black
        
        descriptionTextField = UITextField(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 42, width: UIScreen.main.bounds.width - 110, height: 30))
        descriptionTextField.adjustsFontSizeToFitWidth = true
        descriptionTextField.placeholder = " Date"
        descriptionTextField.layer.borderColor = Constants.aqua.cgColor
        descriptionTextField.layer.borderWidth = 1.0
        descriptionTextField.layer.masksToBounds = true
        descriptionTextField.textColor = UIColor.black
        
        dateTextField = UITextField(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 86, width: UIScreen.main.bounds.width - 110, height: 30))
        dateTextField.adjustsFontSizeToFitWidth = true
        dateTextField.placeholder = " Description"
        dateTextField.layer.borderColor = Constants.aqua.cgColor
        dateTextField.layer.borderWidth = 1.0
        dateTextField.layer.masksToBounds = true
        dateTextField.textColor = UIColor.black
        
        self.view.addSubview(eventNameTextField)
        self.view.addSubview(descriptionTextField)
        self.view.addSubview(dateTextField)
    }

    func setupButtons() {
        
        postButton = UIButton(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 170, width: UIScreen.main.bounds.width - 110, height: 35))
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.backgroundColor = Constants.aqua
        postButton.addTarget(self, action: #selector(postButtonClicked), for: .touchUpInside)
        self.view.addSubview(postButton)
        
        goBackButton = UIButton(frame: CGRect(x: 52, y: 0.6 * UIScreen.main.bounds.height + 217, width: UIScreen.main.bounds.width - 110, height: 35))
        goBackButton.layoutIfNeeded()
        goBackButton.setTitle("Cancel", for: .normal)
        goBackButton.setTitleColor(UIColor.white, for: .normal)
        goBackButton.backgroundColor = Constants.aqua
        goBackButton.addTarget(self, action: #selector(goBackButtonClicked), for: .touchUpInside)
        self.view.addSubview(goBackButton)
        
    }

    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((self.auth?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            withBlock()
            
        })
    }
   
    func postButtonClicked(sender: UIButton!) {
        
        let eventImageData = UIImageJPEGRepresentation(eventImageView.image!, 0.9)
        
        let nameOfEvent = eventNameTextField.text!
        self.eventNameTextField.text = ""
        let eventDescription = descriptionTextField.text!
        self.descriptionTextField.text = ""
        let eventDate = dateTextField.text!
        self.dateTextField.text = ""
        let key2 = self.postsRef.childByAutoId().key
        let storage = FIRStorage.storage().reference().child("eventpics/\(key2)")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.put(eventImageData!, metadata: metadata).observe(.success) { (snapshot) in
            let url = snapshot.metadata?.downloadURL()?.absoluteString
            let newPost = ["eventName": nameOfEvent, "poster": self.currentUser?.name as Any, "interestedPeople": self.noOne, "posterId": self.currentUser?.id! as Any, "description": eventDescription, "date": eventDate, "eventImageUrl": url!, "eventId": key2] as [String : Any]
            let key = self.postsRef.childByAutoId().key
            let childUpdates = ["/\(key)/": newPost]
            self.postsRef.updateChildValues(childUpdates)
        }
        self.performSegue(withIdentifier: "backToFeed", sender: self)

    }
    
    func goBackButtonClicked() {
        self.performSegue(withIdentifier: "backToFeed", sender: self)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //appends each initialized post (w/ key and postDict) into posts array to be displayed
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Social(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            
            //magic happens here??
            self.posts.append(post)
            
            withBlock()
        })
    }
   
    func pickImage(sender: UIButton!) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func takeImage(sender: UIButton!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
}

extension NewSocialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectFromLibraryButton.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
