//
//  NewSocialViewController.swift
//  MDBSocials
//
//  Created by Zach Govani on 2/25/17.
//  Copyright © 2017 Zach Govani. All rights reserved.
//

import UIKit
import Firebase

class NewSocialViewController: UIViewController {
    
    var newPostView: UITextField!
    var newPostTitle: UITextField!
    var newDateView: UITextField!
    var newPostButton: UIButton!
    var newImageView: UIImageView!
    var image_Url: String!
    var currentUser: User!
    var selectFromLibraryButton: UIButton!
    var exitButton: UIButton!
    let picker = UIImagePickerController()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setupNewPostTitle()
        setupNewPostView()
        setupNewDateView()
        setupProfileImageView()
        setupButton()
        setupExitButton()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupNewPostTitle() {
        newPostTitle = UITextField(frame: CGRect(x: 10, y: UIApplication.shared.statusBarFrame.maxY + 40, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height * 0.05))
        //        newPostTitle.layoutIfNeeded()
        newPostTitle.layer.shadowRadius = 2.0
        newPostTitle.layer.masksToBounds = true
        newPostTitle.placeholder = "Title..."
        view.addSubview(newPostTitle)
    }
    
    func setupNewPostView() {
        newPostView = UITextField(frame: CGRect(x: 10, y: newPostTitle.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height * 0.2))
        //        newPostView.layoutIfNeeded()
        newPostView.layer.shadowRadius = 2.0
        newPostView.layer.masksToBounds = true
        newPostView.placeholder = "Description..."
        view.addSubview(newPostView)
    }
    
    func setupNewDateView() {
        newDateView = UITextField(frame: CGRect(x: 10, y: newPostView.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height * 0.1))
        print("i reach here")
        //        newDateView.layoutIfNeeded()
        newDateView.layer.shadowRadius = 2.0
        newDateView.layer.masksToBounds = true
        newDateView.placeholder = "Date..."
        view.addSubview(newDateView)
    }
    
    func setupProfileImageView() {
        newImageView = UIImageView(frame: CGRect(x: 20, y: newDateView.frame.maxY + 20, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40))
        selectFromLibraryButton = UIButton(frame: newImageView.frame)
        selectFromLibraryButton.setTitle("Pick Image From Library", for: .normal)
        selectFromLibraryButton.setTitleColor(UIColor.blue, for: .normal)
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        view.addSubview(newImageView)
        view.addSubview(selectFromLibraryButton)
        view.bringSubview(toFront: selectFromLibraryButton)
    }
    
    
    func setupButton() {
        newPostButton = UIButton(frame: CGRect(x: 10, y: newDateView.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: 50))
        newPostButton.setTitle("Add Post", for: .normal)
        newPostButton.setTitleColor(UIColor.blue, for: .normal)
        //        newPostButton.layoutIfNeeded()
        newPostButton.layer.borderWidth = 2.0
        newPostButton.layer.cornerRadius = 3.0
        newPostButton.layer.borderColor = UIColor.blue.cgColor
        newPostButton.layer.masksToBounds = true
        newPostButton.addTarget(self, action: #selector(addNewPost), for: .touchUpInside)
        view.addSubview(newPostButton)
    }
    
    func setupExitButton() {
        exitButton = UIButton(frame: CGRect(x: UIApplication.shared.statusBarFrame.maxX - 30, y: UIApplication.shared.statusBarFrame.maxY + 10, width: 20, height: 20))
        exitButton.setTitle("X", for: .normal)
        exitButton.setTitleColor(UIColor.blue, for: .normal)
        exitButton.layer.borderWidth = 2.0
        exitButton.layer.cornerRadius = 3.0
        exitButton.layer.borderColor = UIColor.blue.cgColor
        exitButton.layer.masksToBounds = true
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    func exit(sender: UIButton!) {
        self.newImageView.image = nil
        self.newPostView.text = ""
        self.newDateView.text = ""
        self.newPostTitle.text = ""
        self.dismiss(animated: true, completion: nil)
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
        let titleText = newPostTitle.text!
        let dateText = newDateView.text!
        if postText != "" && titleText != "" && dateText != "" && newImageView.image != nil {
            self.newPostView.text = ""
            self.newDateView.text = ""
            self.newPostTitle.text = ""
            let key = postsRef.childByAutoId().key
            setupProfilePic(id: key) {
            let newPost = ["description": postText, "title": titleText, "date": dateText, "poster": self.currentUser?.name, "imageUrl": self.image_Url!, "numLikes": 0, "posterId": self.currentUser!.id, "likers": []] as [String : Any]
            let childUpdates = ["/\(key)/": newPost]
            self.postsRef.updateChildValues(childUpdates)
            }
            self.newImageView.image = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setupProfilePic(id: String, withBlock: @escaping () -> ()) {
        let newImageData = UIImageJPEGRepresentation(newImageView.image!, 0.9)
        let storage = FIRStorage.storage().reference().child("profilepics/\((id))")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.put(newImageData!, metadata: metadata).observe(.success) { (snapshot) in
            self.image_Url = snapshot.metadata?.downloadURL()?.absoluteString
            withBlock()
        }
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
        newImageView.contentMode = .scaleAspectFit
        newImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
}
}
