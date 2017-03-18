//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Amy on 2/21/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class DetailViewController: UIViewController {
    
    
    
   
    static var currentEvent : Social!
   
    var eventView : UIImageView!
    var poster : UILabel!
    var interestedButton : UIButton!
    var eventName: UILabel!
    var interestedUsers : [String] = []
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var descriptionLabel: UILabel!
    var refToUsers = FIRDatabase.database().reference().child("Users")
    var refToPost = FIRDatabase.database().reference().child("Posts")
    static var postIds: [String] = []
    var users: [User] = []
    static var indexPath: Int = 0
    static var numberInterested: UIButton!
    var topView = UIView()
    var middleView = UIView()
    var textBackground = UIImageView()
    var interestedNames: [String] = []
    var interestedPics: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = []
        setupBackground()
        setupTextBackground()
        initImageViewUI()
        
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3))
        topView.backgroundColor = UIColor.clear

        DetailViewController.currentEvent.getEventPic {
            self.eventView.image = DetailViewController.currentEvent.image
        }
        initDescriptionUI()
        initPosterUI()
        initEventNameUI()
        
        middleView = UIView(frame: CGRect(x: 0, y: topView.frame.maxY, width: view.frame.width, height: view.frame.height/3))
        middleView.backgroundColor = UIColor.clear
        middleView.addSubview(descriptionLabel)
        middleView.addSubview(poster)
        middleView.addSubview(eventName)
        initInterestedButton()
        
        initNumberInterestedUI()
        topView.addSubview(eventView)
        view.addSubview(topView)
        view.addSubview(middleView)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInterestedPeople" {
        
            InterestedPeopleViewController.interestedUsers = self.interestedUsers;      InterestedPeopleViewController.interestedNames = self.interestedNames
            InterestedPeopleViewController.interestedPics = self.interestedPics
        }
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
    
    func setupTextBackground() {
        
        textBackground = UIImageView(frame: CGRect(x: 16, y: 350, width: 380, height: 350))
        textBackground.backgroundColor = UIColor.white
        textBackground.layer.cornerRadius = 30
        textBackground.clipsToBounds = true;
        
        view.addSubview(textBackground)
    }
    func fetchInterestedUsers(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = FIRDatabase.database().reference()
        let currIndex = DetailViewController.indexPath
        let key = DetailViewController.postIds[currIndex]
        ref.child("Posts").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject]
            self.users = (postDict?["interestedPeople"])! as! [User]
            withBlock()
        })
    }
    func initImageViewUI() {
        
        eventView = UIImageView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height/3))
        eventView.clipsToBounds = true
        eventView.contentMode = UIViewContentMode.scaleAspectFit
       
    }
    
    func initEventNameUI() {
        eventName = UILabel(frame: CGRect(x: 30, y: (navigationController?.navigationBar.frame.maxY)! + 42, width: view.frame.width - self.view.frame.width * 0.1, height: 40))
        eventName.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        eventName.text = DetailViewController.currentEvent.eventName
        
    }
    
    func initPosterUI() {
        poster = UILabel(frame: CGRect(x: 30, y: self.view.frame.height * 0.2 - 15, width: 100, height: 25))
        poster.textColor = UIColor.init(red: 0, green: 0.7, blue: 0.7, alpha: 1)
        poster.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
        poster.text = "@" + DetailViewController.currentEvent.poster!
    }
    
    
    func initDescriptionUI() {
        descriptionLabel = UILabel(frame: CGRect(x: 30, y: 150, width: view.frame.width - 10, height: 80))
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
        descriptionLabel.text = DetailViewController.currentEvent.eventDescription
        descriptionLabel.numberOfLines = 5
    }
   
    
    func initInterestedButton() {
        interestedButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 125, y: middleView.frame.maxY + 150, width: 250, height: 35))
        interestedButton.setTitle("Interested?", for: .normal)
        interestedButton.backgroundColor = Constants.aqua
        interestedButton.addTarget(self, action: #selector(interestedAction), for: .touchUpInside)
        view.addSubview(interestedButton)
   
    }
    
    func initNumberInterestedUI() {
        DetailViewController.numberInterested = UIButton(frame: CGRect(x: view.frame.width / 2 - 125, y: middleView.frame.maxY + 100, width: 250, height: 35 ))
        DetailViewController.numberInterested.setTitle(String(describing: DetailViewController.currentEvent.interestedNumber) + " interested", for: .normal)
        DetailViewController.numberInterested.backgroundColor = UIColor.init(red: 0, green: 0.9, blue: 0.9, alpha: 1)
        DetailViewController.numberInterested.addTarget(self, action: #selector(displayInterestedPeople), for: .touchUpInside)
        view.addSubview(DetailViewController.numberInterested)
    }
    
    func displayInterestedPeople() {
        fetchInterestedUsers {
            
        }
        performSegue(withIdentifier: "toInterestedPeople", sender: nil)
        

    }
    func interestedAction() {
        interestedButton.setTitle("✓ Interested", for: .normal)
        let currIndex = DetailViewController.indexPath
        let key = DetailViewController.postIds[currIndex]
        FeedViewController.posts[currIndex].interestedNumber += 1
        self.interestedUsers.append((FIRAuth.auth()?.currentUser?.uid)!)
        users.append(FeedViewController.currentUser)
        self.interestedNames.append(FeedViewController.currentUser.name!)
        self.interestedPics.append(FeedViewController.currentUser.imageUrl!)
        let childUpdates = ["interestedPeople": interestedUsers, "interestedNames": interestedNames, "interestedPics": interestedPics] as [String : Any]
        refToPost.child(key).updateChildValues(childUpdates)
        DetailViewController.numberInterested.setTitle(String(describing: (self.interestedUsers.count)) + " interested", for: .normal)
        
        fetchInterestedUsers {
            print("done")
        }

    }
}
