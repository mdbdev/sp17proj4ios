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

class CustomImage : UIImage {
    var url: String!
}

class Post {
    var title: String?
    var imageUrl: String?
    var numLikes: Int?
    var posterId: String?
    var poster: String?
    var id: String?
    var image: CustomImage?
    var description: String?
    var dateString: String?
    
    var postID: String?
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if postDict != nil {
            if let title = postDict!["title"] as? String {
                self.title = title
            }
            if let imageUrl = postDict!["imageURL"] as? String {
                self.imageUrl = imageUrl
            }
            if let numLikes = postDict!["numLikes"] as? Int {
                self.numLikes = numLikes
            }
            if let posterId = postDict!["posterId"] as? String {
                self.posterId = posterId
            }
            if let poster = postDict!["poster"] as? String {
                self.poster = poster
            }
            if let description = postDict!["description"] as? String {
                self.description = description
            }
            if let date = postDict!["dateString"] as? String {
                self.dateString = date
            }
            if let postID = postDict!["postID"] as? String {
                self.postID = postID
            }
        }
    }
    
    func getProfilePic(withBlock: @escaping () -> ()) {
        
        let ref = FIRStorage.storage().reference(forURL: imageUrl!)
        
        self.image?.url = imageUrl
        
        if let imageFromCache = imageCache.object(forKey: imageUrl as AnyObject) as? CustomImage {
            self.image = imageFromCache
            withBlock()
        }
        
        ref.data(withMaxSize: 2048 * 2048 * 2048) { data, error in
            if let error = error {
                print(error)
            } else {
                
                let imageToCache = CustomImage(data: data!)
                
                if self.image?.url == self.imageUrl {
                    self.image = imageToCache
                    withBlock()
                }
                
                self.imageCache.setObject(imageToCache!, forKey: self.imageUrl as AnyObject)
                
                self.image = imageToCache
                withBlock()
            }
        }
    }
}
