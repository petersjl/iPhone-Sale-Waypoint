//
//  GameDetailController.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/21/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
//

import UIKit
import Firebase

class GameDetailController : UIViewController{
    
    var game : DocumentReference!
    var gameSnap : DocumentSnapshot!
    var gameListener : ListenerRegistration!
    var userListener : ListenerRegistration!
    var wishedFor = false
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var steamText: UILabel!
    @IBOutlet weak var psText: UILabel!
    @IBOutlet weak var nintendoText: UILabel!
    @IBOutlet weak var wishlistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishlistButton.titleLabel?.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameListener = game.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("Error in adding gameListener \n \(error)")
                return
            }
            self.game.getDocument { (snapshot, error) in
                if let error = error{
                    print("Error getting game document \n \(error)")
                    return
                }
                self.gameSnap = snapshot!
                self.updateValues()
            }
        })
        userListener = DataManager.userRef?.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("Error finding user document \n \(error)")
                return
            }
            self.wishedFor = (snapshot?.get("wishlist") as! [DocumentReference]).contains(self.game)
            let str = self.wishedFor ? "Remove from wishlist" : "Add to wishlist"
            self.wishlistButton.setTitle(str, for: .normal)
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameListener.remove()
        userListener.remove()
    }
    
    func updateValues(){
        titleText.text = (gameSnap.get("title") as! String)
        priceText.text = "$" + (gameSnap.get("price") as! NSNumber).stringValue
        steamText.text = (gameSnap.get("steamSale") as! NSNumber).stringValue + "%"
        psText.text = (gameSnap.get("psSale") as! NSNumber).stringValue + "%"
        nintendoText.text = (gameSnap.get("nintendoSale") as! NSNumber).stringValue + "%"
    }
    
    @IBAction func pressedWishlist(_ sender: Any) {
        if wishedFor {
            DataManager.userRef?.updateData(["wishlist": FieldValue.arrayRemove([game!])], completion: { (error) in
                if let error = error {
                    print("Error removing game \n \(error)")
                }
            })
        }else{
            DataManager.userRef?.updateData(["wishlist": FieldValue.arrayUnion([game!])], completion: { (error) in
                if let error = error {
                    print("Error removing game \n \(error)")
                }
            })
        }
    }
    @IBAction func pressedUpdateSales(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Update Sales", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Steam Sale", style: .default, handler: { (action) in
            self.updateSteam()
        }))
        alertController.addAction(UIAlertAction(title: "PlayStation Sale", style: .default, handler: { (action) in
            self.updatePS()
            
        }))
        alertController.addAction(UIAlertAction(title: "Nintendo Sale", style: .default, handler: { (action) in
            self.updateNin()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateSteam(){
        let steam = String(steamText!.text!.dropLast())
        let alertController = UIAlertController(title: "Update Sales", message: "Update the Steam sale", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = steam
        }
        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            let num = Int(alertController.textFields![0].text!)
            if num == nil {ScenesManager.showError(parent: self, title: "Error", message: "Entered non number value for sale")}
            if num! > 100 || num! < 0 {
                ScenesManager.showError(parent: self, title: "Error", message: "Sale must be between 0 and 100")
            }
            self.game.updateData(["steamSale" : num! as NSNumber])
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func updatePS(){
        let ps = String(psText!.text!.dropLast())
        let alertController = UIAlertController(title: "Update Sales", message: "Update the PlayStation sale", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = ps
        }
        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            let num = Int(alertController.textFields![0].text!)
            if num == nil {ScenesManager.showError(parent: self, title: "Error", message: "Entered non number value for sale")}
            if num! > 100 || num! < 0 {
                ScenesManager.showError(parent: self, title: "Error", message: "Sale must be between 0 and 100")
            }
            self.game.updateData(["psSale" : num! as NSNumber])
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateNin(){
        let nin = String(nintendoText!.text!.dropLast())
        let alertController = UIAlertController(title: "Update Sales", message: "Update the Nintendo sale", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = nin
        }
        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            let num = Int(alertController.textFields![0].text!)
            if num == nil {ScenesManager.showError(parent: self, title: "Error", message: "Entered non number value for sale")}
            if num! > 100 || num! < 0 {
                ScenesManager.showError(parent: self, title: "Error", message: "Sale must be between 0 and 100")
            }
            self.game.updateData(["nintendoSale" : num! as NSNumber])
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
