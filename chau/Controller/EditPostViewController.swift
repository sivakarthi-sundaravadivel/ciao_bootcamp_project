//
//  EditPostViewController.swift
//  chau
//
//  Created by s.sivakarthi on 12/09/2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class EditPostViewController: UIViewController {

    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postCaption: UITextView!
    
    var postDetails = String()
    
    
    var selectedPostUserId = [String]()
    var selectedPostImage = [String]()
    var selectedPostCaption = [String]()
    var selectedPostId = [String]()
    var selectedPostUserName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        //hide tabbar
//        self.tabBarController?.tabBar.isHidden = true

        userPostData()
    }
    
    func userPostData() {
        
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
                        }
                        if let postUid = document.get("postUid") as? String {
                            self.selectedPostId.append(postUid)
                        }
                        if let userName = document.get("userName") as? String {
                            self.selectedPostUserName.append(userName)
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
    func editPost() {
        let db = Firestore.firestore()
        db.collection("Post").document(postDetails).updateData(["caption": postCaption.text!])
        
    }
    func deletePost() {
        let db = Firestore.firestore()
        db.collection("Post").document(postDetails).delete(){ error in
            
            if error != nil {
                print("error occoured")
            }
            else{
                print("deleted")
            }
            
        }
    }
    func backToProfile() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "homeUi")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func postDeletedAlert() {
        let alert = UIAlertController(title: "successful", message: "your post has been deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction!) in
            self.backToProfile()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func postEditedAlert() {
        let alert = UIAlertController(title: "successful", message: "your post has been edited", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction!) in
            self.backToProfile()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deletePost()
        postDeletedAlert()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        editPost()
        postEditedAlert()
        
    }
    
    

}
