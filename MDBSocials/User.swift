//
//  User.swift
//  MDBSocials
//
//  Created by Amy on 2/21/17.
//  Copyright © 2017 Amy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
class User {
    var name: String?
    var email: String?
    var imageUrl: String?
    var id: String?
    var image: UIImage?
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let name = userDict!["name"] as? String {
                self.name = name
            }
            if let imageUrl = userDict!["imageUrl"] as? String {
                self.imageUrl = imageUrl
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
            
        }
    }
    func getProfilePic(withBlock: @escaping () -> ()) {
        let ref = FIRStorage.storage().reference().child("/profilepics/\(id!)")
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

