//
//  NewsFeedTableViewCell.swift
//  chau
//
//  Created by s.sivakarthi on 11/09/2022.
//

import UIKit
import Firebase
import FirebaseStorage

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var caption: UILabel!
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
