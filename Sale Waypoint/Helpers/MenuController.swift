//
//  MenuController.swift
//  Sale Waypoint
//
//  Created by CSSE Department on 5/19/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

import UIKit
import FirebaseAuth

enum MenuType : Int{
    case wishlist
    case games
    case addgame
    case signout
    case cancel
}

class MenuController : UITableViewController {
    
    var parentView : UIViewController!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = MenuType(rawValue: indexPath.row)
        switch(menu){
        case .wishlist:
            print("Pressed wishlist")
            self.dismiss(animated: true)
            pressedWishlist()
        case .games:
            print("Pressed games")
            self.dismiss(animated: true)
            pressedGames()
        case .addgame:
            print("Pressed add game")
            self.dismiss(animated: true)
            pressedAddGame()
        case .signout:
            print("Pressed sign out")
            self.dismiss(animated: true)
            pressedSignOut()
        case .cancel:
            print("Pressed cancel")
            self.dismiss(animated: true)
        case .none:
            return
        }
    }
    
    func pressedWishlist(){
        ScenesManager.transitionTo(parent: parentView, target: Scene.wishlist)
    }
    
    func pressedGames(){
        ScenesManager.transitionTo(parent: parentView, target: Scene.games)
    }
    
    func pressedAddGame(){
        
    }
    
    func pressedSignOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error signing out")
        }
    }
}