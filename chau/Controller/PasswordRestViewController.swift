//
//  passwordRestViewController.swift
//  chau
//
//  Created by s.sivakarthi on 05/09/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class PasswordRestViewController: UIViewController {

    @IBOutlet var uiExpressionImagePasswordRest: UIImageView!
    
    @IBOutlet var emailInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let uiExpression = UIImage.gifImageWithName("forgotPassword")
        uiExpressionImagePasswordRest.image = uiExpression
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
        resetpassword()
    }
    
    func resetpassword() {
        Auth.auth().sendPasswordReset(withEmail: emailInput.text!) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "sorry", message: "Please enter your registerd email address", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Success", message: "Password reset link has been sent to your registed email", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "signInNavigationUi")
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func passwordalert() {
        
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
