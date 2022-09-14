//
//  addPostViewController.swift
//  chau
//
//  Created by s.sivakarthi on 05/09/2022.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase

class AddPostViewController: UIViewController, UINavigationControllerDelegate {

    //UI connection
    @IBOutlet var newPost: UIImageView!
    @IBOutlet var postCaption: UITextField!
    @IBOutlet var postButton: UIButton!
    
    //user ID
    let userID = Auth.auth().currentUser!.uid

    //initiate database
    private let database = Database.database().reference()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //imageview to clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            newPost.isUserInteractionEnabled = true
            newPost.addGestureRecognizer(tapGestureRecognizer)
        
        
        //check
        print(userID)
        
        //get current time
        let currentDateTime = Date()
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "ddMMyyy"
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "hhmmss"
        
        let date = dateFormat.string(from: currentDateTime)
        
        let time = timeFormat.string(from: currentDateTime)
        
        
        dateAndTime.dateValue = "\(date)\(time)"
        
        currentUserDetails()
        
       
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "homeUi")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func posttry(_ sender: Any) {
        
        newPostUpload()
        newPostUploadNewsfeed()
        postUloadedAlert()
        
    }
    
    func backHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "homeUi")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func postUloadedAlert() {
        let alert = UIAlertController(title: "successful", message: "your new post have been posted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction!) in
            self.backHome()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
   
    
    
   
    
    
    //add immage to imageview
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(Handler) in
            self.cameraImage()

        }))
        alert.addAction(UIAlertAction(title: "Phone", style: .default, handler: {(Handler) in
            self.phoneImage()
                                                                                   
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(Handler) in
                                                                                   
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Capture user profile picture from camera
    func cameraImage() {
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            let image = UIImagePickerController()
//            image.allowsEditing = true
//            image.sourceType = .camera
//            image.mediaTypes = [kUTTypeImage as String]
//            self.present(image, animated: true, completion: nil)
//        }
    }
    
    //Import user profile picture from phone
    func phoneImage() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.delegate = self
            self.present(image, animated: true, completion: nil )
            //check
            print(userID)

        }
    }
    
    func newPostUpload() {
        //check image is nil
        
        guard newPost.image != nil else {
            return
        }
        
        // create storage refference
        let storageRef = Storage.storage().reference()
        
        //convert user profile picture to data
        let imageData = newPost.image!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let postDataPath = "\(userID)/post/\(userID)\(dateAndTime.dateValue).jpg"
        
        let currentUserName = defaultsUserDetails.userName

        
        let fileRef = storageRef.child(postDataPath)
        
        //upload data
        let uploadUserPost = fileRef.putData(imageData!, metadata: nil) { [self]
            metadata,  error in
            
            if error == nil && metadata != nil {
                
                //save a refrence to the file
                let db = Firestore.firestore()
                let fileName = userID + dateAndTime.dateValue
                
                db.collection(userID).document(fileName).setData(["caption": postCaption.text!, "postURL": postDataPath, "userId": userID, "userName": currentUserName, "postUid": fileName])
                
                let object: [String: Any] = [ "caption": postCaption.text!, "postURL": postDataPath, "userId": userID, "userName": currentUserName]
                
                database.child("User").child(userID).child("Post").child(dateAndTime.dateValue).setValue(object)
                

            } else{
                print("error occerd")
            }
        }
        
        let postDataPathToPost = "post/\(userID)\(dateAndTime.dateValue).jpg"
        
        let userName = defaultsUserDetails.userName
        
        let postFileRef = storageRef.child(postDataPathToPost)
        
        let uploadPost = postFileRef.putData(imageData!, metadata: nil) { [self]
            metadata,  error in
            
            if error == nil && metadata != nil {
                
                //save a refrence to the file
                let db = Firestore.firestore()
                let fileName = userID + dateAndTime.dateValue
                
                db.collection("Post").document(fileName).setData(["caption": postCaption.text!, "postURL": postDataPathToPost, "userId": userID, "userName": userName, "postUid": fileName ])
                
                let object: [String: Any] = [ "caption": postCaption.text!, "postURL": postDataPathToPost, "userId": userID, "userName": userName]
                
                database.child("Post").child(userID).child(fileName).setValue(object)
                

            } else{
                print("error occerd")
            }
        }
        
        
        
    }
    
    func newPostUploadNewsfeed() {
        
    }
    
    
    struct dateAndTime {
        static var dateValue = ""
    }
    
    func currentUserDetails() {
        
        let currentUserID = Auth.auth().currentUser!.uid
        
        
        let DatabaseRef = Database.database().reference()
        
        guard currentUserID == Auth.auth().currentUser?.uid else {
            
            print("Something went wrong")
            return
        }
        
        DatabaseRef.child("User").child(currentUserID).child("userDetails").observe(.value) { snapshot in
            
            if let dictionary = snapshot.value as? [String : Any] {
                
                let userNameValue = dictionary["username"] as! String
                let userDOBValue = dictionary["DOB"] as! String
                let userBioValue = dictionary["Bio"] as! String
                let userProfilePicture = dictionary["url"] as! String
                
                defaultsUserDetails.userName = userNameValue
                defaultsUserDetails.userDOB = userDOBValue
                defaultsUserDetails.userId = currentUserID
                
                
                
            }
        }
    }
    

    
}

extension AddPostViewController : UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editingImage = info[UIImagePickerController.InfoKey(rawValue: convertInfoKey(UIImagePickerController.InfoKey.editedImage))] as? UIImage {

            newPost.image = editingImage
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
     
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil )
    }
    
    func convertUIImageToDict(_ input :[UIImagePickerController.InfoKey : Any]) -> [String : Any]{
        return Dictionary(uniqueKeysWithValues: input.map({key , value in (key.rawValue, value)
              
        }))
    }
    
    func convertInfoKey(_ input : UIImagePickerController.InfoKey) -> String{
        return input.rawValue
    }
}
