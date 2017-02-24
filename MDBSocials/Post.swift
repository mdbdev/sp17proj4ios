//
//  Post.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/24/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post {
    
    var author: String?
    var authorId: String?
    var name: String?
    var imageUrl: String?
    var image: UIImage?
    var id: String?
    var interestedUsers: [String] = [] //contains IDs
    var date: String?

}
