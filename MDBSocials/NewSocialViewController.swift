//
//  NewSocialViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/24/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

protocol NewSocialViewControllerDelegate {
    
    func sendValue(_ info: [String : Any])
}

class NewSocialViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var scrollView: UIScrollView!
    var navBar: UINavigationBar!
    var eventPic: UIImageView!
    var uploadPicButton: UIButton!
    let picker = UIImagePickerController()
    var name: TextField!
    var eventDescription: UITextView!
    var scrollTextField: UITextView?
    var date: TextField!
    var postButton: UIButton!
    var delegate: NewSocialViewControllerDelegate? = nil
    var currentUser: User?
    var errorLabel: UILabel!
    var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setUpScrollView()
        self.setUpNavBar()
        fetchUser {
            self.setUpImageView()
            self.setUpUploadPicButton()
            self.setUpTextFields()
            self.setUpPostButton()
            self.registerForKeyboardNotifications() //make keyboard listeners for scrolling text field
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder() //advances to next text field when return is pressed
        } else if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextView {
            // no more text fields after
            nextField.becomeFirstResponder()
        } else {
            dismiss(animated: true, completion: nil)
        }
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") { // go back when line is skipped AKA enter is pressed
            textView.resignFirstResponder()
            postSocial()
        }
        return true
    }
    
    func setUpScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 200)
        view.addSubview(scrollView)
    }
    
    func setUpNavBar() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.09))
        navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navBar.tintColor = UIColor.white
        navBar.barTintColor = Constants.purpleColor
        let navItem = UINavigationItem(title: "New Social")
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navBar.items = [navItem]
        scrollView.addSubview(navBar)

    }
    
    func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpImageView() {
        let dimmension = view.frame.width * 0.6
        eventPic = UIImageView(frame: CGRect(x: view.frame.width / 2 - dimmension / 2, y: navBar.frame.maxY + 20, width: dimmension, height: dimmension))
        eventPic.backgroundColor = UIColor.lightGray
        eventPic.layer.cornerRadius = Constants.regularCornerRadius
        eventPic.layer.masksToBounds = true
        picker.delegate = self
        scrollView.addSubview(eventPic)
    }
    
    func setUpUploadPicButton() {
        uploadPicButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        uploadPicButton.setTitle("Upload Event Picture", for: .normal)
        uploadPicButton.setTitleColor(UIColor.black, for: .normal)
        uploadPicButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: 1)
        uploadPicButton.sizeToFit()
        uploadPicButton.frame.origin.x = eventPic.frame.minX + eventPic.frame.width / 2 - uploadPicButton.frame.width / 2
        uploadPicButton.frame.origin.y = eventPic.frame.minY + eventPic.frame.height / 2 - uploadPicButton.frame.height / 2
        uploadPicButton.addTarget(self, action: #selector(uploadPic), for: .touchUpInside)
        scrollView.addSubview(uploadPicButton)
    }
    
    func uploadPic() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true, completion: nil)
    }
    
    func setUpTextFields() {
        setUpNameTextField()
        setUpDateTextField()
        setUpDescriptonTextField()
        name.delegate = self
        date.delegate = self
        eventDescription.delegate = self
    }
    
    func setUpNameTextField() {
        name = TextField(frame: CGRect(x: view.frame.width / 2 - eventPic.frame.width / 2, y: eventPic.frame.maxY + 15, width: eventPic.frame.width, height: Constants.textFieldHeight))
        name.placeholder = "Event Name"
        name.layer.borderWidth = Constants.regularBorderWidth
        name.layer.cornerRadius = Constants.regularCornerRadius
        name.layer.masksToBounds = true
        name.tag = 0
        scrollView.addSubview(name)
    }
    
    func setUpDateTextField() {
        date = TextField(frame: CGRect(x: view.frame.width / 2 - eventPic.frame.width / 2, y: name.frame.maxY + 15, width: eventPic.frame.width, height: Constants.textFieldHeight))
        date.placeholder = "Event Date, Day and Time"
        date.layer.borderWidth = Constants.regularBorderWidth
        date.layer.cornerRadius = Constants.regularCornerRadius
        date.layer.masksToBounds = true
        date.tag = 1
        scrollView.addSubview(date)
    }
    
    func setUpDescriptonTextField() {
        eventDescription = UITextView(frame: CGRect(x: view.frame.width / 2 - eventPic.frame.width / 2, y: date.frame.maxY + 15, width: eventPic.frame.width, height: 200))
        eventDescription.layer.borderWidth = Constants.regularBorderWidth
        eventDescription.layer.cornerRadius = Constants.regularCornerRadius
        eventDescription.layer.masksToBounds = true
        eventDescription.text = "Event Description" // set placeholder cause textview has no placeholder value
        eventDescription.font = UIFont.systemFont(ofSize: 17)
        eventDescription.textColor = UIColor.lightGray
        eventDescription.tag = 2
        eventDescription.returnKeyType = UIReturnKeyType.go
        scrollView.addSubview(eventDescription)
    }
    
    func setUpPostButton() {
        postButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 40, y: eventDescription.frame.maxY + 10, width: 80, height: 30))
        postButton.setTitle("Post!", for: .normal)
        postButton.backgroundColor = Constants.purpleColor
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.layer.cornerRadius = Constants.regularCornerRadius
        postButton.layer.masksToBounds = true
        postButton.addTarget(self, action: #selector(postSocial), for: .touchUpInside)
        scrollView.addSubview(postButton)
    }
    
    func postSocial() {
        if eventPic.image == nil || name.text! == "" || date.text! == "" || eventDescription.text == "" {
            setUpErrorLabel()
            return
        }
        let image = UIImageJPEGRepresentation(eventPic.image!.imageResize(sizeChange: CGSize(width: 300, height: 300)), 0.9)
        let imageName = NSUUID().uuidString //generate unique id for each image
        let storage = FIRStorage.storage().reference().child("EventPics/\(imageName).png")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        createLoader()
        storage.put(image!, metadata: metadata).observe(.success) { (snapshot) in
            self.loader.removeFromSuperview()
            let url = snapshot.metadata?.downloadURL()?.absoluteString
            self.delegate?.sendValue(["name": self.name.text, "date": self.date.text, "description": self.eventDescription.text, "author": self.currentUser?.name, "authorId": self.currentUser?.id, "imageUrl": url, "interestedUsers": []])
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func createLoader() {
        if let _ = errorLabel { //get rid of error text if it exists
            if errorLabel.text != "" {
                errorLabel.removeFromSuperview()
            }
        }
        loader = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 20, y: postButton.frame.maxY , width: 40, height: 40))
        loader.startAnimating()
        loader.color = UIColor.black
        scrollView.addSubview(loader)
    }
    
    func setUpErrorLabel() {
        errorLabel = UILabel(frame: CGRect(x: 0, y: postButton.frame.maxY + 10, width: 50, height: 5))
        errorLabel.text = "Please fill in all fields."
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorLabel.sizeToFit()
        errorLabel.textColor = UIColor.red
        errorLabel.frame.origin.x = view.frame.width / 2 - errorLabel.frame.width / 2
        scrollView.addSubview(errorLabel)
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        User.generateUserModel(withId: (FIRAuth.auth()?.currentUser?.uid)!, withBlock: { (user) in //generating user in user class
            self.currentUser = user
            withBlock()
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray { //get rid of placeholder text when editing
            textView.text = ""
            textView.textColor = UIColor.black
        }
        scrollTextField = textView
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if eventDescription.text.isEmpty { //if finished editing and text is empty, return to placeholder
            eventDescription.text = "Event Description"
            eventDescription.textColor = UIColor.lightGray
        }
        scrollTextField = nil
    }
    
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: Notification) {
        scrollView.isScrollEnabled = true
        var info = notification.userInfo! //notification comes from NSNotification type
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size //gets keyboard size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var frameWithoutKeyboard : CGRect = view.frame
        frameWithoutKeyboard.size.height -= keyboardSize!.height
        if let activeField = scrollTextField {
            if (!frameWithoutKeyboard.contains(activeField.convert(activeField.frame.origin, to: self.view))){
                // since the texview isn't direct child, coordinates need to be converted first
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.isScrollEnabled = false
    }
}

extension NewSocialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : Any]) {
        uploadPicButton.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventPic.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}

