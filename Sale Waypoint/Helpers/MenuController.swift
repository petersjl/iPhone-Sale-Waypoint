//
//  MenuController.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/19/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
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
            self.dismiss(animated: true)
            pressedWishlist()
        case .games:
            self.dismiss(animated: true)
            pressedGames()
        case .addgame:
            self.dismiss(animated: true)
            pressedAddGame()
        case .signout:
            self.dismiss(animated: true)
            pressedSignOut()
        case .cancel:
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
        ScenesManager.transitionTo(parent: parentView, target: Scene.addgame)
    }
    
    func pressedSignOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error signing out")
        }
    }
}
