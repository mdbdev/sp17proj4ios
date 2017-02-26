//
//  NewPostViewController.swift
//  MDBSocial
//
//  Created by Levi Walsh on 2/25/17.
//  Copyright © 2017 Levi Walsh. All rights reserved.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController {
    
    var newPostView: UITextField!
    var nameView: UITextField!
    var dateView: UITextField!
    var newPostButton: UIButton!
    var user: User?
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    let picker = UIImagePickerController()
    var selectFromLibraryButton: UIButton!
    var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNameView()
        setupDateView()
        setupNewPostView()
        setupProfileImageView()
        setupCreatePostButton()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setupNameView() {
        nameView = UITextField(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 0.1 * UIScreen.main.bounds.height))
        print("i reach here")
        nameView.layoutIfNeeded()
        nameView.layer.shadowRadius = 2.0
        nameView.layer.masksToBounds = true
        nameView.placeholder = "Name of Event"
        view.addSubview(nameView)
    }
    
    func setupDateView() {
        dateView = UITextField(frame: CGRect(x: 10, y: nameView.frame.maxY, width: UIScreen.main.bounds.width - 20, height: 0.1 * UIScreen.main.bounds.height))
        print("i reach here")
        dateView.layoutIfNeeded()
        dateView.layer.shadowRadius = 2.0
        dateView.layer.masksToBounds = true
        dateView.placeholder = "Date of Event"
        view.addSubview(dateView)
    }
    
    func setupNewPostView() {
        newPostView = UITextField(frame: CGRect(x: 10, y: dateView.frame.maxY, width: UIScreen.main.bounds.width - 20, height: 0.2 * UIScreen.main.bounds.height))
        print("i reach here")
        newPostView.layoutIfNeeded()
        newPostView.layer.shadowRadius = 2.0
        newPostView.layer.masksToBounds = true
        newPostView.placeholder = "Description of event"
        view.addSubview(newPostView)
    }
    
    
//    
//    func setupImageButton() {
//        imageButton = UIButton(frame: CGRect(x: 10, y: newPostView.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: 50))
//        imageButton.setTitle("Choose Photo", for: .normal)
//        imageButton.setTitleColor(UIColor.blue, for: .normal)
//        imageButton.layoutIfNeeded()
//        imageButton.layer.borderWidth = 2.0
//        imageButton.layer.cornerRadius = 3.0
//        imageButton.layer.borderColor = UIColor.blue.cgColor
//        imageButton.layer.masksToBounds = true
//        imageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
//        view.addSubview(imageButton)
//    }
    func setupProfileImageView() {
        profileImageView = UIImageView(frame: CGRect(x: 10, y: newPostView.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: 50))
        selectFromLibraryButton = UIButton(frame: profileImageView.frame)
        selectFromLibraryButton.setTitle("Pick Image From Library", for: .normal)
        selectFromLibraryButton.setTitleColor(UIColor.blue, for: .normal)
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        view.addSubview(profileImageView)
        view.addSubview(selectFromLibraryButton)
        view.bringSubview(toFront: selectFromLibraryButton)
        
    }
    
    func setupCreatePostButton() {
        newPostButton = UIButton(frame: CGRect(x: 10, y: profileImageView.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: 50))
        newPostButton.setTitle("Add Post", for: .normal)
        newPostButton.setTitleColor(UIColor.blue, for: .normal)
        newPostButton.layoutIfNeeded()
        newPostButton.layer.borderWidth = 2.0
        newPostButton.layer.cornerRadius = 3.0
        newPostButton.layer.borderColor = UIColor.blue.cgColor
        newPostButton.layer.masksToBounds = true
        newPostButton.addTarget(self, action: #selector(addNewPost), for: .touchUpInside)
        view.addSubview(newPostButton)
    }
    
    func pickImage(sender: UIButton!) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func addNewPost(sender: UIButton!) {
        //TODO: Implement using Firebase!
        let postText = newPostView.text!
        let nameOfEvent = nameView.text!
        let dateOfEvent = nameView.text!
        let profileImageData = UIImageJPEGRepresentation(profileImageView.image!, 0.9)
        let storage = FIRStorage.storage().reference().child("profilepics/\((FIRAuth.auth()?.currentUser?.uid)!)")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.put(profileImageData!, metadata: metadata).observe(.success) { (snapshot) in
            let url = snapshot.metadata?.downloadURL()?.absoluteString
            
            self.newPostView.text = ""
            let newPost = ["name": nameOfEvent, "date": nameOfEvent, "text": postText, "poster": self.user?.name, "numLikes": 0, "posterId": self.user?.id, "imageURL": url] as [String : Any]
            let key = self.postsRef.childByAutoId().key
            let childUpdates = ["/\(key)/": newPost]
            self.postsRef.updateChildValues(childUpdates)
            self.dismiss(animated: true, completion: nil)
            // Find a way to go back here
            // performSegue(withIdentifier: "NewPostToFeed", sender: self)
        }
        
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
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
}

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
