//
//  NewPostViewController.swift
//  MDBSocials
//
//  Created by Mark Siano on 2/24/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox
import Firebase

class NewPostViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate {
    
    var button: UIButton!
    var imageView: UIImageView!
    
    var titleField: CustomTextField!
    var descriptionField: UITextView!
    
    var auth = FIRAuth.auth()
    
    var navBar: UINavigationBar!
    var height: CGFloat!
    
    var placeholderLabel : UILabel!
    
    var addImageButton: UIButton!
    var removeImagesButton: UIButton!
    
    var images: [UIImage] = []
    
    var datePicker: UIDatePicker!
    
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser {
            self.navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
            self.view.addSubview(self.navBar);
            let navItem = UINavigationItem(title: "New Post");
            let doneItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.done, target: nil, action: #selector  (self.makePost))
            
            let backItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: nil, action: #selector  (self.goBack))
            
            //let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(getter: UIAccessibilityCustomAction.selector));
            navItem.rightBarButtonItem = doneItem
            navItem.leftBarButtonItem = backItem
            self.navBar.setItems([navItem], animated: false);
            
            self.initTextFields()
            self.initImageView()
            self.initButtons()
            self.initDatePicker()
        }
        
        //initImagePicker()
        
        // Do any additional setup after loading the view.
    }
    
    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func initDatePicker() {
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: imageView.frame.minY - 120, width: view.frame.width, height: 120))
        datePicker.layer.borderColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
        datePicker.layer.borderWidth = 1.0
        
        view.addSubview(datePicker)
    }
    
    func makePost() {
        //Add the image into storage
        
        if images != nil && titleField.text != "" && descriptionField.text != "" {
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("post_images").child("\(imageName).png")
            
            var imageToUpload: UIImage!
            
            var heightToWidthRatio = images[0].size.height / images[0].size.width
            
            if heightToWidthRatio > mainInstance.heightToWidthScalingFactor {
                let width = images[0].size.width
                var scalingFactor = mainInstance.imageWidth / width
                imageToUpload = resizeImage(image: images[0], targetSize: CGSize(width: scalingFactor * width, height: scalingFactor * images[0].size.height))
            } else {
                let height = images[0].size.height
                var scalingFactor = mainInstance.imageHeight / height
                imageToUpload = resizeImage(image: images[0], targetSize: CGSize(width: scalingFactor * images[0].size.width, height: scalingFactor * height))
            }
            
            if let uploadData = UIImagePNGRepresentation(imageToUpload) {
                
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let user = FIRAuth.auth()?.currentUser
                        let uid = user?.uid
                        
                        let userLiked = ["value": self.currentUser?.id] as [String: Any]
                        
                        let keyRef = self.postsRef.childByAutoId()
                        
                        let newPost = ["title": self.titleField.text!, "poster": self.currentUser?.firstname, "imageURL": profileImageUrl, "numLikes": 0, "posterId": self.currentUser?.id, "description": self.descriptionField.text!, "dateString": self.datePicker.date.description, "postID": keyRef.key] as [String : Any]
                        
                        let key = keyRef.key
                        let childUpdates = ["/\(key)/": newPost]
                        
                        let usersLikedRef = keyRef.child("Users Liked")
                        
                        //let usersLikedKey = usersLikedRef.childByAutoId()
                        let usersLikedUpdates = ["/\(key)": userLiked]
                        
                        self.postsRef.updateChildValues(childUpdates)
                        //usersLikedRef.updateChildValues(usersLikedUpdates)
                    }
                    
                    _ = self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("Posts").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func initButtons() {
        addImageButton = UIButton(frame: CGRect(x: imageView.frame.maxX, y: imageView.frame.minY, width: view.frame.width - imageView.frame.width, height: imageView.frame.height / 2))
        addImageButton.setTitle("Add Photos", for: .normal)
        addImageButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18.0)
        addImageButton.setTitleColor(UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: .normal)
        addImageButton.layer.borderColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
        addImageButton.layer.borderWidth = 1.0
        
        view.addSubview(addImageButton)
        
        removeImagesButton = UIButton(frame: CGRect(x: imageView.frame.maxX, y: addImageButton.frame.maxY, width: view.frame.width - imageView.frame.width, height: imageView.frame.height / 2))
        removeImagesButton.setTitle("Remove Photos", for: .normal)
        removeImagesButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18.0)
        removeImagesButton.setTitleColor(UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), for: .normal)
        removeImagesButton.layer.borderColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
        removeImagesButton.layer.borderWidth = 1.0
        
        //Add targets
        addImageButton.addTarget(self, action: #selector(initImagePicker), for: UIControlEvents.touchUpInside)
        
        view.addSubview(removeImagesButton)
    }
    
    func initImageView() {
        let height = CGFloat(180)
        imageView = UIImageView(frame: CGRect(x: 0, y: view.frame.maxY - height, width: height, height: height))
        
        imageView.image = UIImage(named: "default.png")
        
        view.addSubview(imageView)
    }
    
    func initTextFields() {
        height = 40
        titleField = CustomTextField(frame: CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width, height: height))
        titleField.placeholder = "Event Title"
        
        view.addSubview(titleField)
        
        descriptionField = UITextView(frame: CGRect(x: 0, y: titleField.frame.maxY, width: view.frame.width, height: height * 2))
        descriptionField.font = UIFont.init(name: "Roboto-Regular", size: 16.0)
        //descriptionField.placeholder = "Event Description"
        
        descriptionField.delegate = self
        descriptionField.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5)
        placeholderLabel = UILabel()
        placeholderLabel.text = "Event Description"
        placeholderLabel.textColor = UIColor.init(red: 199/255, green: 199/255, blue: 205/255, alpha: 1.0)
        placeholderLabel.sizeToFit()
        placeholderLabel.font = UIFont.init(name: "Roboto-Regular", size: 16.0)
        descriptionField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 10, y: (descriptionField.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !descriptionField.text.isEmpty
        //postText.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        view.addSubview(descriptionField)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
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
    
    func initImagePicker() {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print(datePicker.date);
        if images[0] != nil {
            imageView.image! = images[0]
            self.images = images
            print(self.images)
        } else {
            imageView.image! = UIImage(named: "default.png")!
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //Resize images before uploading for faster downloads (saves unnecessary space and makes downloads faster)
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
