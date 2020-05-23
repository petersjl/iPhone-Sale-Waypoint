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
    
    var presenter : LoginController!
    
    @IBAction func pressedSignUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if let error = error {
                let strerr = error.localizedDescription
                if strerr.contains("6 characters"){
                    ScenesManager.showError(parent: self, title: "Sign Up Error", message: "Passwords must be 6 characters long or more.")
                    return
                }
                if strerr.contains("be provided"){
                    ScenesManager.showError(parent: self, title: "Sign Up Error", message: "Email cannot be left empty.")
                    return
                }
                if strerr.contains("badly formatted"){
                    ScenesManager.showError(parent: self, title: "Sign Up Error", message: "Email address is badly formatted")
                    return
                }
                if strerr.contains("already in use"){
                    ScenesManager.showError(parent: self, title: "Sign Up Error", message: "This email is already in use by another account.")
                    return
                }
                ScenesManager.showError(parent: self, title: "Sign Up Error", message: "An unknown error occured.")
                print("Error creating new user \n \(error)")
                return
            }
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (result, error) in
                if let error = error{
                    print("Error logging in after signup \n \(error)")
                }
                
            }
            self.dismiss(animated: true) {
                self.presenter.signIn()
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
