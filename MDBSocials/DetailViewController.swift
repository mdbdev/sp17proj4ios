//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/25/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var post: Post!
    var image: UIImageView!
    var name: UILabel!
    var author: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPic()
        setUpName()
        setUpAuthor()
    }
    
    func setUpPic() {
        let dimmension = view.frame.width * 0.4
        image = UIImageView(frame: CGRect(x: view.frame.width * 0.05, y: (navigationController?.navigationBar.frame.maxY)! + 30, width: dimmension, height: dimmension))
        image.layer.cornerRadius = 5
        image.backgroundColor = UIColor.black
        image.layer.masksToBounds = true
        view.addSubview(image)
    }
    
    func setUpName() {
        name = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        name.text = post.name
        name.font = UIFont.systemFont(ofSize: 23, weight: 1)
        name.sizeToFit()
        name.frame.origin.y = image.frame.minY + 20
        name.frame.origin.x = image.frame.maxX + ((view.frame.width - image.frame.maxX) / 2) - name.frame.width / 2
        view.addSubview(name)
    }
    
    func setUpAuthor() {
        author = UILabel(frame: CGRect(x: 0, y: name.frame.maxY + 5, width: 50, height: 50))
        author.text = "Posted by " + post.name!
        author.font = UIFont.systemFont(ofSize: 14)
        author.sizeToFit()
        author.frame.origin.x = image.frame.maxX + ((view.frame.width - image.frame.maxX) / 2) - author.frame.width / 2
        view.addSubview(author)
    }

}
