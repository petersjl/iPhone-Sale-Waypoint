//
//  AddGameController.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/21/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddGameController : UIViewController {
    var authListenerHandle : AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var steamText: UITextField!
    @IBOutlet weak var psText: UITextField!
    @IBOutlet weak var nintendoText: UITextField!
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "☰", style: .plain, target: self, action: #selector(menu))
    navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(displayP3Red: 220/255, green: 26/255, blue: 0, alpha: 1)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if Auth.auth().currentUser == nil{
                ScenesManager.destination = Scene.wishlist.rawValue
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    @objc func menu(){
        ScenesManager.showMenu(parent: self)
    }
    
    @IBAction func pressedAdd(_ sender: Any) {
        let title = titleText.text!
        let price = Double(priceText.text!)
        let steam = Int(steamText.text!)
        let ps = Int(psText.text!)
        let nin = Int(nintendoText.text!)
        
        // Title cannot be empty
        if title == ""{
            ScenesManager.showError(parent: self, title: "Error", message: "Title cannot be empty.")
            return
        }
        // Check for incorrect imput types
        if price == nil || steam == nil || ps == nil || nin == nil {
            ScenesManager.showError(parent: self, title: "Error", message: "Entered non number in a number field.")
            return
        }
        // Price must be greater than zero
        if price! <= 0 {
            ScenesManager.showError(parent: self, title: "Error", message: "Price must be greater than zero.")
            return
        }
        // Discounts must be between 0 and 100
        if steam! < 0 || ps! < 0 || nin! < 0 || steam! > 100 || ps! > 100 || nin! > 100{
            ScenesManager.showError(parent: self, title: "Error", message: "All percents must be between 0 and 100")
            return
        }
        
        var err = false
        DataManager.gamesRef.addDocument(data: [
            "title" : title,
            "price" : price! as NSNumber,
            "steamSale" : steam! as NSNumber,
            "psSale" : ps! as NSNumber,
            "nintendoSale" : nin! as NSNumber]) { (error) in
            if let error = error{
                ScenesManager.showError(parent: self, title: "Error", message: "There was a problem submitting the game.")
                print("Error creating document \n \(error)")
                err = true
                return
            }
        }
        if err{
            return
        }
        ScenesManager.transitionTo(parent: self, target: Scene.games)
    }
}

extension AddGameController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ScenesManager.transition.isPresenting = true
        return ScenesManager.transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ScenesManager.transition.isPresenting = false
        return ScenesManager.transition
    }
}
