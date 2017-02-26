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
 
    var createSocial: UIButton!
    var goBackButton: UIButton!
    var selectFromLibraryButton: UIButton!
    let picker = UIImagePickerController()
    var newPostView: UITextField!
    var newPostButton: UIButton!
    var postCollectionView: UICollectionView!
    var posts: [Social] = []
    var auth = FIRAuth.auth()
    var users: [User] = []
    var currentUser: User!
    var newEventName: UITextField!
    var eventImageView: UIImageView!
    var interestedUsers: [String] = []
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEventImageView()
        picker.delegate = self
        self.fetchUser() {
            print("done")
        }
        // Do any additional setup after loading the view.
        setupTextFields()
      
        setupButtons()
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       func setupTextFields() {
        // sets up name of event, description, and date text fields
        
        eventNameTextField = UITextField(frame: CGRect(x: 10, y: 0.6 * UIScreen.main.bounds.height - 40, width: UIScreen.main.bounds.width - 20, height: 30))
        eventNameTextField.adjustsFontSizeToFitWidth = true
        eventNameTextField.placeholder = "Event Name"
        eventNameTextField.layoutIfNeeded()
        eventNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        eventNameTextField.layer.borderWidth = 1.0
        eventNameTextField.layer.masksToBounds = true
        eventNameTextField.textColor = UIColor.black
        self.view.addSubview(eventNameTextField)
        
        
        descriptionTextField = UITextField(frame: CGRect(x: 10, y: 0.6 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 30))
        descriptionTextField.adjustsFontSizeToFitWidth = true
        descriptionTextField.placeholder = "Event Description"
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextField.layer.borderWidth = 1.0
        descriptionTextField.layer.masksToBounds = true
        descriptionTextField.textColor = UIColor.black
        descriptionTextField.isSecureTextEntry = true
        self.view.addSubview(descriptionTextField)
        
        dateTextField = UITextField(frame: CGRect(x: 10, y: 0.6 * UIScreen.main.bounds.height + 40, width: UIScreen.main.bounds.width - 20, height: 30))
        dateTextField.adjustsFontSizeToFitWidth = true
        dateTextField.placeholder = "Date"
        dateTextField.layer.borderColor = UIColor.lightGray.cgColor
        dateTextField.layer.borderWidth = 1.0
        dateTextField.layer.masksToBounds = true
        dateTextField.textColor = UIColor.black
        self.view.addSubview(dateTextField)
       
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
    func setupEventImageView() {
        eventImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40))
        selectFromLibraryButton = UIButton(frame: eventImageView.frame)
        selectFromLibraryButton.setTitle("Pick Image From Library", for: .normal)
        selectFromLibraryButton.setTitleColor(UIColor.blue, for: .normal)
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        view.addSubview(eventImageView)
        view.addSubview(selectFromLibraryButton)
        view.bringSubview(toFront: selectFromLibraryButton)
        
    }
   
    func createNewPost(sender: UIButton!) {
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
            //ref.setValue(["name": name, "email": email, "imageUrl": url, "userName" : userName])
            //self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
          
            let newPost = ["eventName": nameOfEvent, "test": "where are you", "poster": self.currentUser?.name as Any, "userImageUrl": self.currentUser?.imageUrl as Any, "interestedPeople": self.interestedUsers, "posterId": self.currentUser?.id! as Any, "description": eventDescription, "date": eventDate, "eventImageUrl": url!, "eventId": key2] as [String : Any]
            let key = self.postsRef.childByAutoId().key
            let childUpdates = ["/\(key)/": newPost]
            self.postsRef.updateChildValues(childUpdates)
           
        }
        
    
        
            

                    
        
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupNewPostView() {
        newPostView = UITextField(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 0.3 * UIScreen.main.bounds.height))
        print("i reach here")
        newPostView.layoutIfNeeded()
        newPostView.layer.shadowRadius = 2.0
        newPostView.layer.masksToBounds = true
        newPostView.placeholder = "Write a new post..."
        view.addSubview(newPostView)
    }
    
   
    
    func setupButtons() {
        
        createSocial = UIButton(frame: CGRect(x: 10, y: 0.8 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 30))
        createSocial.layoutIfNeeded()
        createSocial.setTitle("Create Social", for: .normal)
        createSocial.setTitleColor(UIColor.blue, for: .normal)
        createSocial.layer.borderWidth = 2.0
        createSocial.layer.cornerRadius = 3.0
        createSocial.layer.borderColor = UIColor.blue.cgColor
        createSocial.layer.masksToBounds = true
        createSocial.addTarget(self, action: #selector(createNewPost), for: .touchUpInside)
        self.view.addSubview(createSocial)
        
       
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
