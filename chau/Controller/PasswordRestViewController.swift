//
//  passwordRestViewController.swift
//  chau
//
//  Created by s.sivakarthi on 05/09/2022.
//

import UIKit

class PasswordRestViewController: UIViewController {

    @IBOutlet var uiExpressionImagePasswordRest: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let uiExpression = UIImage.gifImageWithName("forgotPassword")
        uiExpressionImagePasswordRest.image = uiExpression
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
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
