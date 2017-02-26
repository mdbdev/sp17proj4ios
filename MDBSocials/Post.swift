//
//  Post.swift
//  FirebaseDemoWeek3
//
//  Created by Sahil Lamba on 2/13/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Post {
    var description: String?
    var imageUrl: String?
    var numLikes: Int?
    var posterId: String?
    var poster: String?
    var id: String!
    var likers: [String]!
    var image: UIImage?
    
    
    init(id: String, postDict: [String:Any]) {
        self.id = id
        if let text = postDict["description"] as? String {
            self.description = text
        }
        if let imageUrl = postDict["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        if let numLikes = postDict["numLikes"] as? Int {
            self.numLikes = numLikes
        }
        if let posterId = postDict["posterId"] as? String {
            self.posterId = posterId
        }
        if let poster = postDict["poster"] as? String {
            self.poster = poster
        }
        if let likers = postDict["likers"] as? [String] {
            self.likers = likers
        } else {
            self.likers = []
        }
        
    }
    
    init() {
        self.description = "This is a god dream"
        self.imageUrl = "https://cmgajcmusic.files.wordpress.com/2016/06/kanye-west2.jpg"
        self.id = "1"
        self.numLikes = 0
        self.poster = "Kanye West"
        self.likers = []
    }
    
    func getProfilePic(withBlock: @escaping () -> ()) {
        let ref = FIRStorage.storage().reference().child("/profilepics/\(posterId!)")
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
