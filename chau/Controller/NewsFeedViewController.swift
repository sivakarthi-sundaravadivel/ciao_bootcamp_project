//
//  newsFeedViewController.swift
//  chau
//
//  Created by s.sivakarthi on 05/09/2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var postDetails = String()
    
    
    @IBOutlet var newsFeedTable: UITableView!
    
    var postUserId = [String]()
    var postImage = [String]()
    var postCaption = [String]()
    var postId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsFeedTable.delegate = self
        newsFeedTable.dataSource = self
    
        getPostData()
        
        self.newsFeedTable.reloadData()
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(menuButtonTapped))

        // Adding button to navigation bar (rightBarButtonItem or leftBarButtonItem)
        self.navigationItem.rightBarButtonItem = barButtonItem
    
    }
    
    @objc fileprivate func menuButtonTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "addPostUi")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }
    
    func getPostData() {
        
    
        let fireStoreDatabase = Firestore.firestore()

        
        fireStoreDatabase.collection("Post").addSnapshotListener { snapshot, error in
            if error != nil {
                print("Error occord")
            }
            else {
                
                
                if snapshot?.isEmpty != true {
                    self.postUserId.removeAll(keepingCapacity: false)
                    self.postCaption.removeAll(keepingCapacity: false)
                    self.postImage.removeAll(keepingCapacity: false)
                    self.postId.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        self.postId.append(document.documentID)
                        
                        if let username = document.get("userName") as? String {
                            self.postUserId.append(username)
                        }
                        if let caption = document.get("caption") as? String {
                            self.postCaption.append(caption)
                        }
                        if let imageUrl = document.get("postURL") as? String {
                            self.postImage.append(imageUrl)
                        }
                        
                        
                        
                    }
                    
                    
                    self.newsFeedTable.reloadData()
                    
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count is \(postId.count)")
        return postUserId.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storageRef = Storage.storage().reference()

        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! NewsFeedTableViewCell
        cell.caption.text = postCaption[indexPath.row]
        cell.userName.text = postUserId[indexPath.row]
        
        let fileRef = storageRef.child(postImage[indexPath.row])
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil {

                let image = UIImage(data: data!)

                cell.postImage.image = image
            }
        }
        
        return cell
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = newsFeedTable.indexPathForSelectedRow {
            print("indexPath: ", indexPath)
        // Get the new view controller using segue.destination.
            guard let detailVC = segue.destination as? PostDetailsViewController else {return}
        // Pass the selected object to the new view controller.
            detailVC.postDetails = postId[indexPath.row]
        }
    }
    
}
