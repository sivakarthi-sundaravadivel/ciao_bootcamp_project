//
//  profileViewController.swift
//  chau
//
//  Created by s.sivakarthi on 05/09/2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    // UI connection
    @IBOutlet var userProfilePicture: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userDOB: UILabel!
    @IBOutlet var userBio: UILabel!
    
    @IBOutlet var profilePostTable: UITableView!
    
    var profilePath = [String]()
    
    
    var postUserId = [String]()
    var postImage = [String]()
    var postCaption = [String]()
    var postId = [String]()
    
    
    //user ID
    let userID = Auth.auth().currentUser!.uid

    //initiate database
    private let database = Database.database().reference()

    var imgRef : StorageReference{
        let profilePicturePath = "\(userID)/profilePicture/userDP.jpg"
        return Storage.storage().reference().child(profilePicturePath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide tabbar
        self.tabBarController?.tabBar.isHidden = false
        
        profilePostTable.delegate = self
        profilePostTable.dataSource = self
        
        //user profile picture mask to rounded corners
        userProfilePicture.layer.masksToBounds = true
        userProfilePicture.layer.cornerRadius = userProfilePicture.bounds.width / 2

        retriveUserData()
        
        userPostData()
        self.profilePostTable.reloadData()
        
    

    }
    
    func retriveUserData() {
        
        let db = Firestore.firestore()
        
        let DatabaseRef = Database.database().reference()
        
        guard userID == Auth.auth().currentUser?.uid else {
            
            print("Something went wrong")
            return
        }
        
        DatabaseRef.child("User").child(userID).child("userDetails").observe(.value) { snapshot in
            
            if let dictionary = snapshot.value as? [String : Any] {
                
                let userNameValue = dictionary["username"] as! String
                let userDOBValue = dictionary["DOB"] as! String
                let userBioValue = dictionary["Bio"] as! String
                let userProfilePicture = dictionary["url"] as! String
                
                self.userName.text = userNameValue
                self.userDOB.text = userDOBValue
                self.userBio.text = userBioValue
                
                let storageRef = Storage.storage().reference()
                let fileRef = storageRef.child(userProfilePicture)
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if error == nil && data != nil {

                        let image = UIImage(data: data!)

                        self.userProfilePicture.image = image


                    }
            }
        }
            
            
        
            
            
        
        
//        let fireStoreDatabase = Firestore.firestore()
//        fireStoreDatabase.collection(userID).getDocuments { snapshot, error in
//            if error != nil{
//                print("Error")
//            }
//            else{
//                    
//                    for document in snapshot!.documents{
//                        
//                        let data = document.data()
//                        if let profilePath = data["url"] as? String {
//                            
//                            let profilePath = profilePath
//                        }
//                        
//                       
//                    }
//                for path in self.profilePath {
//                    
//                    print("url is in ::::::::\(self.profilePath)")
//               
//                                   let storageRef = Storage.storage().reference()
//                                   let fileRef = storageRef.child(path)
//                                   fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                                       if error == nil && data != nil {
//               
//                                           let image = UIImage(data: data!)
//               
//                                           self.userProfilePicture.image = image
//               
//               
//                                       }
//                                   }
//                               }
//                
//                
//            }
//        
////        let docRef = db.collection(userID).document("profilePicture")
////
////        docRef.getDocument { snapshot, error in
////
////
////            if error == nil && snapshot != nil {
////
////                var profilePath = [String]()
////
////                for doc in snapshot!.documents {
////                    //profilePath.append(doc["url"] as! String )
////                    self.profilePath.append(doc["url"] as! String)
////                }
////
////                for path in profilePath {
////
////                    let storageRef = Storage.storage().reference()
////                    let fileRef = storageRef.child(path)
////                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
////                        if error == nil && data != nil {
////
////                            let image = UIImage(data: data!)
////
////                            self.userProfilePicture.image = image
////
////
////                        }
////                    }
////                }
////            }
////        }
//        
//        
        
    }
    
    }
    
    func userPostData() {
        let fireStoreDatabase = Firestore.firestore()

        
        fireStoreDatabase.collection("Post").addSnapshotListener { snapshot, error in
            if error != nil {
                print("Error occord")
            }
            else {
                
                self.postUserId.removeAll(keepingCapacity: false)
                self.postCaption.removeAll(keepingCapacity: false)
                self.postImage.removeAll(keepingCapacity: false)
                self.postId.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents{
                    
                   
                    
                    self.postId.append(document.documentID)
                    
                    if self.userID == document.get("userId") as? String {
                        
                        if let username = document.get("userId") as? String {
                            self.postUserId.append(username)
                        }
                        if let caption = document.get("caption") as? String {
                            self.postCaption.append(caption)
                        }
                        if let imageUrl = document.get("postURL") as? String {
                            self.postImage.append(imageUrl)
                        }
                        
                        
                    }
                }
                    
                
            }
                self.profilePostTable.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postUserId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let storageRef = Storage.storage().reference()

        let cell = tableView.dequeueReusableCell(withIdentifier: "profilePostCell", for: indexPath)
        cell.textLabel?.text = postCaption[indexPath.row]
        
        
        let fileRef = storageRef.child(postImage[indexPath.row])
        
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil {

                let image = UIImage(data: data!)

                cell.imageView?.image = image
            }
        }
        
        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = profilePostTable.indexPathForSelectedRow {
            print("indexPath: ", indexPath)
        // Get the new view controller using segue.destination.
            guard let detailVC = segue.destination as? EditPostViewController else {return}
        // Pass the selected object to the new view controller.
            detailVC.postDetails = postId[indexPath.row]
        }
    }
   


}
