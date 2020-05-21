//
//  LoginController.swift
//  Sale Waypoint
//
//  Created by CSSE Department on 5/18/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Rosefire

class LoginController : UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        self.performSegue(withIdentifier: Scene.signup.rawValue, sender: self)
    }
    
    @IBAction func pressedRoseFire(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
          if let err = err {
            print("Rosefire sign in error! \(err)")
            return
          }
         // print("Result = \(result!.token!)")
          print("Result = \(result!.username!)")
          print("Result = \(result!.name!)")
          print("Result = \(result!.email!)")
          print("Result = \(result!.group!)")
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
        print("Signing in user: \(Auth.auth().currentUser?.uid)")
        let ref = DataManager.usersRef
        let lis = ref.whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { (querry, error) in
            if let error = error{
                print("Error making listener \n \(error)")
                self.signOut()
                return
            }
            print(querry?.documents.count)
            if querry?.documents.count == 0{
                self.createUserDoc()
                return
            }
            let first = querry?.documents.first
            DataManager.userRef = first?.reference
            self.finishSignIn()
        }
        
        
        
//        print(DataManager.gamesRef)
//        let listener = DataManager.gamesRef.addSnapshotListener({ (snapshot, error) in
//            if let error = error{
//                print("Error getting user document reference \n \(error)")
//                self.signOut()
//                return
//            }
//            print("Signed in user id: \(Auth.auth().currentUser!.uid)")
//            snapshot!.documents.forEach({ (document) in
//                print(document)
//            })
//            DataManager.userRef = snapshot?.documents.first?.reference
//        })
//        listener.remove()
//        if(DataManager.userRef == nil){
//            print("Error finding user document")
//            self.signOut()
//            return
//        }
//        signedIn = true
//        print("Successful sign in")
//        self.performSegue(withIdentifier: Scene.wishlist.rawValue, sender: self)
    }
    
    func finishSignIn(){
        print("userRef: \(DataManager.userRef)")
        if DataManager.userRef == nil{
            print("Could not assign userRef")
            signOut()
            return
        }
        DataManager.signedIn = true
        print("Successful sign in")
        self.performSegue(withIdentifier: Scene.wishlist.rawValue, sender: self)
    }
    
    func createUserDoc(){
        print("Creating new user document")
        DataManager.usersRef.addDocument(data: [
            "uid" : Auth.auth().currentUser!.uid,
            "wishlist" : []]) { (error) in
                if let error = error{
                    print("Error creating new user document \n \(error)")
                    return
                }
        }
        signIn()
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            print("Signed out with error")
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
                performSegue(withIdentifier: ScenesManager.destination, sender: self)
            }
        }
    }
}
