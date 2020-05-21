//
//  SignUpController.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/18/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpController : UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func pressedSignUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if let error = error {
                print("Error creating new user \n \(error)")
                return
            }
            self.dismiss(animated: true) {
                return
            }
        }
    }
    @IBAction func pressedCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            return
        }
    }
}
