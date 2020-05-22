//
//  LoginController.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/18/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Rosefire

class LoginController : UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userListener : ListenerRegistration!
    let signUpSegue = "SignUpSegue"
    let wishlistSegue = "ToWishlistSegue"
    let REGISTRY_TOKEN = "bf49ca66-1a09-408c-a84f-5b66667f9e74"
    
    @IBAction func tempLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: "a@b.com", password: "123456") { (result, error) in
            if let error = error{
                print("Auto sign in error \n \(error)")
            }
            self.signIn()
        }
    }
    @IBAction func pressedLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if let error = error{
                print("Error signing in with Email/Password \n \(error)")
            }
            self.signIn()
        }
    }
    
    @IBAction func pressedSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    @IBAction func pressedRoseFire(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
          if let err = err {
            print("Rosefire sign in error! \(err)")
            return
          }
         // print("Result = \(result!.token!)")
//          print("Result = \(result!.username!)")
//          print("Result = \(result!.name!)")
//          print("Result = \(result!.email!)")
//          print("Result = \(result!.group!)")
            Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
                if let error = error {
                  print("Firebase sign in error! \(error)")
                  return
                }
             //User is signed in using Firebase!
                self.signIn()
            }
        }
    }
    
    func signIn(){
        let ref = DataManager.usersRef
        userListener = ref.whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { (querry, error) in
            if let error = error{
                print("Error making listener \n \(error)")
                self.signOut()
                return
            }
            if querry?.documents.count == 0{
                self.createUserDoc()
                return
            }
            let first = querry?.documents.first
            DataManager.userRef = first?.reference
            self.finishSignIn()
        }
    }
    
    func finishSignIn(){
        userListener.remove()
        if DataManager.userRef == nil{
            print("Could not assign userRef")
            signOut()
            return
        }
        DataManager.signedIn = true
        print("Successful sign in")
        self.performSegue(withIdentifier: wishlistSegue, sender: self)
    }
    
    func createUserDoc(){
        print("Creating new user document")
        userListener.remove()
        DataManager.usersRef.addDocument(data: [
            "uid" : Auth.auth().currentUser!.uid,
            "wishlist" : []]) { (error) in
                if let error = error{
                    print("Error creating new user document \n \(error)")
                    return
                }
                self.signIn()
        }
        
    }
    
    func signOut(){
        userListener.remove()
        do{
            try Auth.auth().signOut()
            print("Signed out with error")
            ScenesManager.showError(parent: self, title: "Sign in Error", message: "Error trying to sign in. \n Signed user out")
        }catch{
            print("Error signing out from error")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ScenesManager.rootView = self
        if Auth.auth().currentUser != nil {
            if !DataManager.signedIn{
                signIn()
            }else{
                performSegue(withIdentifier: wishlistSegue, sender: self)
            }
        }
    }
}
