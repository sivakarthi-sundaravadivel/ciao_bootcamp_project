//
//  signUpViewController.swift
//  chau
//
//  Created by s.sivakarthi on 05/09/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    // UI connection
    @IBOutlet var emailInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var confirmPasswordInput: UITextField!
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var uiExpressionSignUp: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let uiExpression = UIImage.gifImageWithName("signUp")
        uiExpressionSignUp.image = uiExpression
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        valication()
    }
    
    func valication() {
        if emailInput.text?.isEmpty == true || passwordInput.text?.isEmpty == true || confirmPasswordInput.text?.isEmpty == true  {
            
            let alert = UIAlertController(title: "Empty Inputs", message: "Please enter your all needed inputs", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if passwordInput.text != confirmPasswordInput.text {
            
            let alert = UIAlertController(title: " Password is not matching", message: "password an confirm passworrd can't be different", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        signUp()
    }
    
    func signUp(){
        Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!){(authResult, error) in
            
            if error != nil {
                print("error occored::::\(String(describing: error))")
            }
            
            self.userCreated()
            
        
        }
    }
    
    func userCreated() {
        let alert = UIAlertController(title: "Success", message: "ciao! User has been Created", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "userDetailsUi")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
