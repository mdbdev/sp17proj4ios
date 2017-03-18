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
    var postText: String?
    var imageUrl: String?
    var numLikes: Int?
    var poster: String?
    var id: String?
    var posterId: String?
    var guests: [String]!
    var image: UIImage?
    var title: String?
    var date: String?
    var go: goingStatus!
    
    enum goingStatus {
        case going
        case notGoing
    }
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        self.go = Post.goingStatus.notGoing
        if let postText = postDict!["text"] as? String {
            self.postText = postText
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
        if let title = postDict?["title"] as? String {
            self.title = title
        }
        if let date = postDict?["date"] as? String {
            self.date = date
        }
        if let posterId = postDict?["posterId"] as? String {
            self.posterId = posterId
        }
        if let guests = postDict?["guests"] as? [String] {
            self.guests = guests
        } else {
            self.guests = []
        }

    }
    
    func getImage(withBlock: @escaping (_ profileImage: UIImage) -> ()) {
        let ref = FIRStorage.storage().reference()
        let imageRef = ref.child("/profilepics/\(id!)")
        imageRef.data(withMaxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    withBlock(UIImage(data: data!)!)
                }
            }
        }
    }
    
    init() {
        // Post I was using for testing. Keep here in case I need again.
//        self.postText = "Come on Son"
//        self.imageUrl = "https://archived.moe/files/gd/image/1395/38/1395382283712.jpg"
//        self.id = "1"
//        self.numLikes = 0
//        self.poster = "Brutan Gaster"
    }
    
    func addInterestedUser(withId: String) {
        let ref: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
        self.guests.append(withId)
        let childUpdates = ["\(self.id!)/likers": self.guests!]
        ref.updateChildValues(childUpdates)
    }
}
