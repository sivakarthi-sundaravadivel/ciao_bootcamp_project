//
//  signInViewController.swift
//  chau
//
//  Created by s.sivakarthi on 05/09/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    // UI connection
    @IBOutlet var emailInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var siginInExpression: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //textview to clickable

        let uiExpression = UIImage.gifImageWithName("signIn")
        siginInExpression.image = uiExpression
    
       
        
        // Do any additional setup after loading the view.
    }
    
    
    
    

    @IBAction func signInButtonTapped(_ sender: Any) {
        
        validation()
    }
    
    //validate user inputs
    func validation() {
        if emailInput.text?.isEmpty == true {
            let alert = UIAlertController(title: "Email is empty", message: "Please enter your email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        if passwordInput.text?.isEmpty == true {
            let alert = UIAlertController(title: "Password is empty", message: "Please enter your password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        signIn()
    }
    
    //user auth initation
    func signIn() {
        Auth.auth().signIn(withEmail: emailInput.text!, password: passwordInput.text!) { [weak self] authResult, error in

            if error != nil {
                let alert = UIAlertController(title: "failed", message: "invalid username or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil))
                self!.present(alert, animated: true, completion: nil)
            }

            self?.checkUser()

        }
    }
    
    //check user signin
    func checkUser() {
        
        if Auth.auth().currentUser != nil{
            print(Auth.auth().currentUser?.uid ?? "user logedin")
            
            //authentication navigation
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "homeUi")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)

        }
    }
    
    

}
