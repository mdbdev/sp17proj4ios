//
//  User.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/24/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class User {
    var name: String?
    var email: String?
    var username: String?
    var id: String?
    
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let name = userDict!["name"] as? String {
                self.name = name
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
            if let username = userDict!["username"] as? String {
                self.username = username
            }
        }
    }
    
    static func generateUserModel(withId: String, withBlock: @escaping (User) -> Void) {
        let childRef = FIRDatabase.database().reference().child("Users").child(withId)
        childRef.observeSingleEvent(of: .value, with: { snapshot in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            withBlock(user)
        })
    }
}
