//
//  PostDetailsViewController.swift
//  chau
//
//  Created by s.sivakarthi on 13/09/2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class PostDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var postDetails = String()
    
    //user ID
    var userID = Auth.auth().currentUser!.uid
    
    //username
    var userName = String()
    
    let commandIcon = UIImageView()
    
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postUserName: UIView!
    @IBOutlet var postedByUsername: UILabel!
    @IBOutlet var commentsTableView: UITableView!
    
    @IBOutlet var postUserId: UILabel!
    @IBOutlet var postCaption: UILabel!
    @IBOutlet var postUserImage: UIImageView!
    @IBOutlet var commandInput: UITextField!
    
    @IBOutlet var commentSendButton: UIButton!
    
    var selectedPostUserId = [String]()
        var selectedPostImage = [String]()
        var selectedPostCaption = [String]()
        var selectedPostId = [String]()
        var selectedPostUserName = [String]()
        

        
        var postComment = [String]()
        var commentId = [String]()
        var postCommentUserName = [String]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            commentsTableView.delegate = self
            commentsTableView.dataSource = self
            
            
            postUserImage.layer.masksToBounds = true
            postUserImage.layer.cornerRadius = postUserImage.bounds.width / 2
            
            
            postUserId.isHidden = true
            
            selectedPostDetails()
            postProfileDetails()
            
            
            
            //get current time
            let currentDateTime = Date()
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "ddMMyyy"
            
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "hhmmss"
            
            let date = dateFormat.string(from: currentDateTime)
            
            let time = timeFormat.string(from: currentDateTime)
            
            
            DateAndTime.dateValue = "\(date)\(time)"
            
            retriveComments()
            self.commentsTableView.reloadData()

            
           
        }
        
        @IBAction func commentButtonTapped(_ sender: Any) {
            
            postProfileDetails()
            addComment()
            commandInput.text = ""

        }
        
        @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
            
            if tapGestureRecognizer.state == .ended {
                
                
                getUsername()
                addComment()
                print("UIImageView tapped\(userName)")
                
            }
            
        }
        
        func getUsername() {
            let fireStoreDatabase = Firestore.firestore()

            
            fireStoreDatabase.collection("Post").addSnapshotListener { snapshot, error in
                if error != nil {
                    print("Error occord")
                }
                else {
                    let db = Firestore.firestore()
                    
                    let DatabaseRef = Database.database().reference()
                    
                    guard self.userID == Auth.auth().currentUser?.uid else {
                        
                        print("Something went wrong")
                        return
                    }
                    
                    DatabaseRef.child("User").child(self.userID).child("userDetails").observe(.value) { snapshot  in
                        
                        if let dictionary = snapshot.value as? [String : Any] {
                            
                            let userNameValue = dictionary["username"] as! String
                            
                            
                            self.userName = userNameValue
                            
                            
                        }
                    }
                    
                }
            }
            
        }
        
        func addComment() {
            let db = Firestore.firestore()
            
            let commentId = "\(userID)\(DateAndTime.dateValue)"
            print("value:::::\(commentId)")
            
            db.collection("Post").document(postDetails).collection("comments").document(commentId).setData(["username": userName, "comment": commandInput.text!, "Defaultcomment": "Defaultcomment"])
            
        }
        
        
        
        func selectedPostDetails() {
            
            let fireStoreDatabase = Firestore.firestore()

            
            let storageRef = Storage.storage().reference()
            
            fireStoreDatabase.collection("Post").addSnapshotListener { [self] snapshot, error in
                if error != nil {
                    print("Error occord")
                }
                else {
                    
                    print("uservalu user id\(defaultsUserDetails.userId)")
                    
                    for document in snapshot!.documents{
                        self.selectedPostId.append(document.documentID)
                        
                        
                        
                        if postDetails == document.get("postUid") as? String {
                            
                            
                            
                            if let caption = document.get("caption") as? String {
                                self.selectedPostCaption.append(caption)
                                self.postCaption.text = caption
                                print("uservalu user id\(caption)")
                                
                            }
                            if let userId = document.get("userId") as? String {
                                self.selectedPostUserId.append(userId)
                                self.postUserId.text = userId

                            }
                            if let postUid = document.get("postUid") as? String {
                                self.selectedPostId.append(postUid)
                            }
                            if let userName = document.get("userName") as? String {
                                self.selectedPostUserName.append(userName)
                                self.postedByUsername.text = userName
                            }
                            
                            if let imagePath = document.get("postURL") as? String {
                                self.selectedPostImage.append(imagePath)
                                
                                let fileRef = storageRef.child(imagePath)
                                
                                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                    if error == nil && data != nil {

                                        let image = UIImage(data: data!)

                                        self.postImage.image = image
                                    }
                                }
                            }
                        }
                        
                    }
                        
                    
                }
                   
            }
        }
        
        func postProfileDetails() {
            let DatabaseRef = Database.database().reference()
            
            DatabaseRef.child("User").child(postUserId.text!).child("userDetails").observe(.value) { snapshot   in
                
                if let dictionary = snapshot.value as? [String : Any] {
                    
                    
                    let userProfilePicture = dictionary["url"] as! String
                    
                    
                    
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(userProfilePicture)
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil {
                            
                            let image = UIImage(data: data!)
                            
                            self.postUserImage.image = image
                            
                            
                            
                        }
                    }
                }
            }
        }
        
        struct DateAndTime {
            static var dateValue = ""
        }
        
        func retriveComments() {
            let fireStoreDatabase = Firestore.firestore()
            
            fireStoreDatabase.collection("Post").document(postDetails).collection("comments").addSnapshotListener { snapshot, error in
                if error != nil {
                    print("error occored")
                }
                else {
                    self.postComment.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        self.commentId.append(document.documentID)
                        let defaultComment = "Defaultcomment"
                        
                        if defaultComment == document.get("Defaultcomment") as? String {
                            
                            if let commentUsername = document.get("username") as? String {
                                self.postCommentUserName.append(commentUsername)
                            }
                            if let commentData = document.get("comment") as? String {
                                self.postComment.append(commentData)
                            }
                        }
                        
                        
                    }
                }
                self.commentsTableView.reloadData()
            }
            
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return postComment.count
        }
        
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath)
            cell.textLabel?.text = postCommentUserName[indexPath.row]
            cell.detailTextLabel?.text = postComment[indexPath.row]
            
            return cell

        }
        
        
        
        

        
    }
