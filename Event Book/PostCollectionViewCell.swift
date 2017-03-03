//
//  PostCollectionViewCell.swift
//  FirebaseDemoWeek3
//
//  Created by Sahil Lamba on 2/13/17.
//  Copyright © 2017 Sahil Lamba. All rights reserved.
//

import UIKit
import FaveButton
import Firebase
import FirebaseAuth

protocol ExpandedCellDelegate : NSObjectProtocol {
    func likePressed(indexPath: IndexPath)
}

class CustomImageView : UIImageView {
    var imageUrl: String!
}

class PostCollectionViewCell: UICollectionViewCell {
    
    var post: Post!
    
    var profileImage: CustomImageView!
    var posterText: UILabel!
    var postText: UITextView!
    var likeButton: UIButton!
    var authorText: UILabel!
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    
    var expanded = false
    
    var expandButton: UIButton! //50 by 8
    
    public var indexPath: IndexPath!
    
    var addPostButton: UIButton!
    weak var delegate: ExpandedCellDelegate?
    
    var shapeLayer: CAShapeLayer!
    var linePath: UIBezierPath!
    
    var faveButton: FaveButton!
    
    var favorited = false
    
    var i = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setupProfileImage()
        setupPosterText()
        //setupBezier()
        setupAuthorText()
        setupPostText()
        setupLikeButton()
        
        setupFaveButton()
        
        //postText.isHidden = true
        likeButton.isHidden = true
        
        setupExpandButton()
    }
    
    func setupFaveButton() {
        print("fave button setup", favorited)
        i += 1
        //faveButton = FaveButton(frame: CGRect(x: contentView.frame.width - 50, y: 10, width: 40, height: 40))
        faveButton = FaveButton(frame: CGRect(x: contentView.frame.width - 50, y: 10, width: 40, height: 40),   faveIconNormal: UIImage(named: "heart"))
        faveButton.addTarget(self, action: #selector(faveClicked), for: UIControlEvents.touchUpInside)
        faveButton.delegate = self
            
        //faveButton.layer.zPosition = 1000
        
        contentView.addSubview(faveButton)
        
        if mainInstance.isFaved[indexPath.row] {
            print("faved")
            faveButton.animateOnSelect = false
            faveButton.isSelected = true
            faveButton.animateOnSelect = true
        } else {
            faveButton.animateOnSelect = false
            faveButton.isSelected = false
            faveButton.animateOnSelect = true
        }
    }
    
    func faveClicked() {
        mainInstance.isFaved[indexPath.row] = !mainInstance.isFaved[indexPath.row]
        if mainInstance.isFaved[indexPath.row] {
            
            let dbRef = FIRDatabase.database().reference()
            
            let keyRef = self.postsRef
            
            let userId = (FIRAuth.auth()?.currentUser?.uid)!
            
            let userLiked = [userId: FIRAuth.auth()?.currentUser?.uid] as [String : Any]
            
            //let key = keyRef.key
            let specificRef = keyRef.child((mainInstance.postCollectionView.cellForItem(at: indexPath) as! PostCollectionViewCell).post.postID!) //The reference to the specific post
            
            //specificRef.child("numLikes").setValue((specificRef.child("numLikes") as! Int) + 1)
            
            let key = specificRef.key
            
            let usersLikedRef = specificRef.child("Users Liked")
            let usersLikedKey = usersLikedRef.child(userId)
            
            dbRef.child("Posts").child(usersLikedRef.key).observeSingleEvent(of: .value, with: { (snapshot) in
                print(usersLikedKey.key)
                print(usersLikedRef.key)
                if snapshot.hasChild(usersLikedKey.key) {
                    print("KLJFKLJDFA")
                } else {
                    let update = ["/\(key)/": userLiked]
                    
                    //usersLikedRef.updateChildValues(update)
                    usersLikedKey.setValue(userLiked[(FIRAuth.auth()?.currentUser?.uid)!])
                    mainInstance.posts[self.indexPath.row].numLikes! += 1
                    specificRef.child("numLikes").setValue(mainInstance.posts[self.indexPath.row].numLikes)
                }
            })
            
            
        } else {
            let keyRef = self.postsRef
            
            let userId = (FIRAuth.auth()?.currentUser?.uid)!
            
            let userLiked = [userId: FIRAuth.auth()?.currentUser?.uid] as [String : Any]
            
            //let key = keyRef.key
            let specificRef = keyRef.child((mainInstance.postCollectionView.cellForItem(at: indexPath) as! PostCollectionViewCell).post.postID!) //The reference to the specific post
            
            let key = specificRef.key
            
            let usersLikedRef = specificRef.child("Users Liked")
            let usersLikedKey = usersLikedRef.child(userId)
            
            usersLikedKey.removeValue()
            
            /*let update = ["/\(key)/": userLiked]
            
            //usersLikedRef.updateChildValues(update)
            usersLikedKey.setValue(userLiked[(FIRAuth.auth()?.currentUser?.uid)!])*/
            mainInstance.posts[indexPath.row].numLikes! -= 1
            specificRef.child("numLikes").setValue(mainInstance.posts[indexPath.row].numLikes)
        }
    }
    
    func updateShit() {
        /*expanded = !expanded
        if expanded {
            postText.isHidden = false
            //setupPostText()
        } else {
            postText.isHidden = true
        }*/
        //contentView.addSubview(faveButton)
        print("updated - ", i)
    }
    
    func setupExpandButton() {
        expandButton = UIButton(frame: CGRect(x: contentView.frame.maxX - 50, y: authorText.frame.minY, width: 50, height: 8))
        expandButton.setImage(UIImage.init(named: "expand.png"), for: .normal)
        
        expandButton.addTarget(self, action: #selector(likePressed), for: UIControlEvents.touchUpInside)
        
        contentView.addSubview(expandButton)
    }
    
    func setupAuthorText() {
        authorText = UILabel(frame: CGRect(x: posterText.frame.minX + 1, y: posterText.frame.maxY + mainInstance.spacing + mainInstance.spacing - 3, width: self.frame.width, height: 10))
        authorText.textColor = UIColor.init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
        authorText.font = UIFont.init(name: "Roboto-Regular", size: 10.0)
        
        contentView.addSubview(authorText)
    }
    
    func setupDateText() {
        
    }
    
    func setupProfileImage() {
        //var scalingFactor = CGFloat((profileImage.image?.size.height)! / (profileImage.image?.size.width)!)
        
        let imageHeight = CGFloat(200.0)
        let imageWidth = contentView.frame.width
        
        mainInstance.imageWidth = imageWidth
        mainInstance.imageHeight = imageHeight
        
        print("height: ", imageHeight)
        print("widht: ", imageWidth)
        mainInstance.heightToWidthScalingFactor = CGFloat(CGFloat(imageHeight) / CGFloat(imageWidth))
        
        profileImage = CustomImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        
        profileImage.layer.zPosition = -1000
        
        //profileImage.layer.borderWidth = 1.0
        //profileImage.layer.borderColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
    
        //addSubview(profileImage)
        contentView.addSubview(profileImage)
    }
    
    //Title
    func setupPosterText() {
        posterText = UILabel(frame: CGRect(x: 20, y: profileImage.frame.maxY - 22 - 30, width: self.frame.width, height: 22))
        posterText.textColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        posterText.textAlignment = NSTextAlignment.left
        posterText.font = UIFont.init(name: "Roboto-Light", size: 22.0)
        posterText.adjustsFontForContentSizeCategory = true
        
        //posterText.layer.borderColor = UIColor.lightGray.cgColor
        //posterText.layer.borderWidth = 1.0
        
        contentView.addSubview(posterText)
    }
    
    //Description
    func setupPostText() {
        postText = UITextView(frame: CGRect(x: 0, y: profileImage.frame.maxY + mainInstance.spacing + 10, width: self.frame.width, height: 150))
        postText.font = UIFont.init(name: "Roboto-Regular", size: 12.0)
        postText.textColor = UIColor.black
        postText.adjustsFontForContentSizeCategory = true
        postText.textAlignment = NSTextAlignment.left
        postText.isEditable = false
        postText.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        postText.contentInset = UIEdgeInsets.init(top: -9, left: 0, bottom: 0, right: 0)
        
        //postText.layer.borderColor = UIColor.lightGray.cgColor
        //postText.layer.borderWidth = 1.0
        
        contentView.addSubview(postText)
    }
    
    func setupLikeButton() {
        likeButton = UIButton(frame: CGRect(x: 10, y: profileImage.frame.minY + 10, width: 50, height: 30))
        likeButton.setTitle("Like", for: .normal)
        likeButton.setTitle("Unlike", for: .selected)
        likeButton.setTitleColor(UIColor.blue, for: .normal)
        
        likeButton.addTarget(self, action: #selector(likePressed), for: UIControlEvents.touchUpInside)
        
        contentView.addSubview(likeButton)
    }
    
    func likePressed() {
        if let delegate = self.delegate{
            delegate.likePressed(indexPath: indexPath)
        }
    }
    
    //Sets up line separators
    func setupBezier() {
        linePath = UIBezierPath()
        
        linePath.move(to: CGPoint.init(x: profileImage.frame.maxX + 8, y: posterText.frame.maxY + mainInstance.spacing))
        linePath.addLine(to: CGPoint.init(x: contentView.frame.width - 8, y: posterText.frame.maxY + mainInstance.spacing))
        
        //linePath.move(to: CGPoint.init(x: 0, y: 50))
        //linePath.addLine(to: CGPoint.init(x: 300, y: 50))
        
        linePath.close()
        linePath.stroke()
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 0.5
        
        contentView.layer.addSublayer(shapeLayer)
        
        /*linePath.move(to: CGPoint.init(x: 0, y: height / 2))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: height / 2))
        linePath.move(to: CGPoint.init(x: 0, y: (height / 2) * 2))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: (height / 2) * 2))
        linePath.move(to: CGPoint.init(x: 0, y: (height / 2) * 3))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: (height / 2) * 3))
        linePath.move(to: CGPoint.init(x: 0, y: (height / 2) * 4))
        linePath.addLine(to: CGPoint.init(x: Int(roundedView.frame.width), y: (height / 2) * 4))
        linePath.close()
        linePath.stroke()*/
    }
    
    override func prepareForReuse() {
        
        profileImage.image = nil
        
        super.prepareForReuse()
    }
}
