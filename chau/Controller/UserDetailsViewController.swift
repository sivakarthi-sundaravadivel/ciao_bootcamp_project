//
//  UserDetailsViewController.swift
//  chau
//
//  Created by s.sivakarthi on 05/09/2022.
//

import UIKit
import MobileCoreServices
import Firebase
import SwiftUI
import AuthenticationServices
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate {

    // UI connection
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userName: UITextField!
    @IBOutlet var userDOB: UITextField!
    @IBOutlet var userDescription: UITextView!
    
    
    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var uiExpressionUserDetails: UIImageView!
    //date piker initiate
    let datePicker = UIDatePicker()
   
    //user ID
    let userID = Auth.auth().currentUser!.uid

    //initiate database
    private let database = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        let uiExpression = UIImage.gifImageWithName("userDetails")
        uiExpressionUserDetails.image = uiExpression
//        //hide back button signup
//        self.navigationItem.setHidesBackButton(true, animated: true)
//
        //hide tabbar
        self.tabBarController?.tabBar.isHidden = true
        
        //user profile picture mask to rounded corners
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.width / 2

        //check
        print(userID)

        
        //imageview to clickable
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            userProfileImage.isUserInteractionEnabled = true
            userProfileImage.addGestureRecognizer(tapGestureRecognizer)
    
        
        //user DOB date picker call
        userDOBPikker()
        
        database.child("UserProfile").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            print("value is::: \(value)")
        })
            
            
    }
    
    //add user profile picture to image view
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
        //check
        print(userID)

       
    }
    
    //Capture user profile picture from camera
    func cameraImage() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.sourceType = .camera
            image.mediaTypes = [kUTTypeImage as String]
            self.present(image, animated: true, completion: nil)
        }
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
    
    
    
    //user DOB date picker function
    func userDOBPikker() {
        
        // tool bar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        
        // initiate toolbar with date picker
        userDOB.inputAccessoryView = toolbar
        
        userDOB.inputView = datePicker
        
        // date picker mode
        
        datePicker.datePickerMode = .date
        //check
        print(userID)

        
    }
    
    @objc func doneTapped() {
        
        // date formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        
        // place date in text field
        userDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true )
        
    }
    
    //initiate to add user details to firebase
    @IBAction func continueButtonTapped(_ sender: Any) {
        // validation and initiate function
        if userName.text?.isEmpty == false || userDOB.text?.isEmpty == false || userDescription.text.isEmpty == false {
            uploadUserDetails()
            homeNavigation()
        }
        else {
                        
            return
        }
    
    }
    
    func uploadUserDetails() {
        
        //check image is nil
        
        guard userProfileImage.image != nil else {
            return
        }
        
        // create storage refference
        let storageRef = Storage.storage().reference()
        
        //convert user profile picture to data
        let imageData = userProfileImage.image!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
//        let profilePicturePath = "\(userID)/profilePicture/\(UUID().uuidString).jpg"
        let profilePicturePath = "\(userID)/profilePicture/userDP.jpg"
//        let profilePicturePathRef = "\(UUID().uuidString).jpg"
        
        let fileRef = storageRef.child(profilePicturePath)
        
        //upload data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { [self]
            metadata,  error in
            
            if error == nil && metadata != nil {
                
                //save a refrence to the file
                let db = Firestore.firestore()
                
                db.collection(userID).document("profilePicture").setData(["url": profilePicturePath])
                
                let object: [String: Any] = [ "username": userName.text! , "DOB": userDOB.text!, "Bio": userDescription.text!, "url": profilePicturePath]
                
                database.child("User").child(userID).child("userDetails").setValue(object)
                
                //check
                print(userID)

            }
        }
        
    }
    
    func homeNavigation()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "homeUi")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
  
    
    

}


extension UserDetailsViewController : UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editingImage = info[UIImagePickerController.InfoKey(rawValue: convertInfoKey(UIImagePickerController.InfoKey.editedImage))] as? UIImage {

            userProfileImage.image = editingImage
            
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
