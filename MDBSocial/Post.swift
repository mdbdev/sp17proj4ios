//
//  Post.swift
//  
//
//  Created by Levi Walsh on 2/22/17.
//
//

import Foundation
import Firebase

class Post {
    var text: String?
    var imageUrl: String?
    var numLikes: Int?
    var poster: String?
    var id: String?
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if postDict != nil {
            if let text = postDict!["text"] as? String {
                self.text = text
            }
            if let imageUrl = postDict!["imageUrl"] as? String {
                self.imageUrl = imageUrl
            }
            if let numLikes = postDict!["numLikes"] as? Int {
                self.numLikes = numLikes
            }
            if let poster = postDict!["poster"] as? String {
                self.poster = poster
            }
        }
    }
    
    func getImage () {
        let imagesRef = FIRStorage.storage().reference().child("profilepics")
        
    }
    
    init() {
        self.text = "Come on Son"
        self.imageUrl = "https://archived.moe/files/gd/image/1395/38/1395382283712.jpg"
        self.id = "1"
        self.numLikes = 0
        self.poster = "Brutan Gaster"
    }
}
