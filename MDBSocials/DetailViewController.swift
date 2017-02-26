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
    
   
    static var numberInterested: UIButton!
    var topView = UIView()
    var middleView = UIView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        initImageViewUI()
        initPosterUI()
        initEventNameUI()
        initNumberInterestedUI()
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3))
        topView.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        
        
        topView.addSubview(eventView)
        topView.addSubview(poster)
        topView.addSubview(eventName)
        
        
        
        
        initDescriptionUI()
        
        
        middleView = UIView(frame: CGRect(x: 0, y: topView.frame.maxY, width: view.frame.width, height: view.frame.height/3))
        middleView.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        middleView.addSubview(descriptionLabel)
   
       
        DetailViewController.currentEvent.getEventPic {
            self.eventView.image = DetailViewController.currentEvent.image
        }
        
        initInterestedButton()
        view.addSubview(topView)
        view.addSubview(middleView)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInterestedPeople" {
            
            InterestedPeopleViewController.interestedUsers = self.interestedUsers
        }
    }
    
    
    func initImageViewUI() {
        
        eventView = UIImageView(frame: CGRect(x: 20, y: (navigationController?.navigationBar.frame.maxY)! + 10, width: 150, height: 150))
        eventView.clipsToBounds = true
        eventView.contentMode = UIViewContentMode.scaleAspectFit
        
       
    }
    
    func initEventNameUI() {
        eventName = UILabel(frame: CGRect(x: eventView.frame.maxX, y: (navigationController?.navigationBar.frame.maxY)! + 10, width: view.frame.width - eventView.frame.width, height: 40))
        eventName.textAlignment = NSTextAlignment.center
        eventName.text = DetailViewController.currentEvent.eventName
        
        
    }
    
    func initPosterUI() {
        poster = UILabel(frame: CGRect(x: eventView.frame.maxX, y: eventView.frame.maxY, width: view.frame.width - eventView.frame.width, height: 25))
        poster.textAlignment = NSTextAlignment.center
        
        poster.text = DetailViewController.currentEvent.poster
        
    }
    
    
    func initDescriptionUI() {
        descriptionLabel = UILabel(frame: CGRect(x: 150, y: 80, width: view.frame.width, height: 80))
        descriptionLabel.textAlignment = NSTextAlignment.center
        descriptionLabel.text = DetailViewController.currentEvent.eventDescription
    
    }
   
    
    func initInterestedButton() {
        interestedButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 125, y: middleView.frame.maxY + 80, width: 250, height: 35))
        interestedButton.setTitle("Interested", for: .normal)
        
        interestedButton.backgroundColor = UIColor.init(red:190/255, green:110/255, blue: 110/255, alpha: 1.0)
        interestedButton.addTarget(self, action: #selector(interestedAction), for: .touchUpInside)
        view.addSubview(interestedButton)
    }
    func initNumberInterestedUI() {
        DetailViewController.numberInterested = UIButton(frame: CGRect(x: view.frame.width / 2 - 125, y: middleView.frame.maxY + 100, width: 250, height: 35 ))
        DetailViewController.numberInterested.setTitle(String(describing: DetailViewController.currentEvent.interestedNumber) + " interested", for: .normal)
        DetailViewController.numberInterested.backgroundColor = UIColor.init(red:190/255, green:110/255, blue: 110/255, alpha: 1.0)
        DetailViewController.numberInterested.addTarget(self, action: #selector(displayInterestedPeople), for: .touchUpInside)
        view.addSubview(DetailViewController.numberInterested)
    }
    func displayInterestedPeople() {
        
        performSegue(withIdentifier: "toInterestedPeople", sender: nil)

    }
    func interestedAction() {
        interestedButton.setTitle("x Interested", for: .normal)
        interestedUsers.append(FeedViewController.currentUser.id!)
        DetailViewController.numberInterested.setTitle(String(describing: (DetailViewController.currentEvent.interestedNumber + 1)) + "interested", for: .normal)
        
        //child updates here 
        
        let referenceIntoEvent = postsRef.child(DetailViewController.currentEvent.id!)
        referenceIntoEvent.child("interestedPeople").setValue(interestedUsers)
    
 
    }
}
