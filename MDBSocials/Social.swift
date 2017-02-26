//
//  Social.swift
//  MDBSocials
//
//  Created by Amy on 2/21/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Social {
    var eventName: String?
    var eventDescription: String?
    var eventImageUrl: String?
    var numLikes: Int?
    var posterId: String?
    var poster: String?
    var id: String?
    var image: UIImage?
    var interestedNumber = 0
    var interestedPeople2 : [String] = []
   
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if postDict != nil {
            if let text = postDict!["eventName"] as? String {
                self.eventName = text
            }
            if let ID = postDict!["eventId"] as? String {
                self.id = ID
            }
            if let description = postDict!["description"] as? String {
                self.eventDescription = description
            }
            if let imageUrl = postDict!["eventImageUrl"] as? String {
                self.eventImageUrl = imageUrl
            }
            if let interestedNumber = postDict!["interestedNumber"] as? Int {
                self.interestedNumber = interestedNumber
            }
            if let posterId = postDict!["posterId"] as? String {
                self.posterId = posterId
            }
            if let poster = postDict!["poster"] as? String {
                self.poster = poster
            }
            if let interestedPpl = postDict!["interestedPeople"] as? [String] {
                self.interestedPeople2 = interestedPpl
            }
        }
    }
    
    
    
    func getEventPic(withBlock: @escaping () -> ()) {
        
        let ref = FIRStorage.storage().reference().child("/eventpics/\(id!)")
        ref.data(withMaxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                print(error)
            } else {
                self.image = UIImage(data: data!)
                withBlock()
            }
        }
        
    }
    
}
