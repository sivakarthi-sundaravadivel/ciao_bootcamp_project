//
//  SettingViewController.swift
//  chau
//
//  Created by s.sivakarthi on 09/09/2022.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    @IBOutlet var aboutImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide tabbar
        self.tabBarController?.tabBar.isHidden = true
        
        let uiExpression = UIImage.gifImageWithName("about")
        aboutImage.image = uiExpression

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func logutButtonTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            userSignOutAlert()
            

        }
        catch{
            print("Unexpected Error")
        }
    }
    
    func backToSignin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signInNavigationUi")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func userSignOutAlert() {
        let alert = UIAlertController(title: "Thank you", message: "See you soon, ciao!!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction!) in
            self.backToSignin()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
