//
//  ScenesManager.swift
//  Sale Waypoint
//
//  Created by CSSE Department on 5/19/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

import UIKit
import FirebaseAuth

enum Scene : String {
    case wishlist = "ToWishlistSegue"
    case signup = "SignUpSegue"
    case games = "ToGameListSegue"
    case addgame = "1"
}

class ScenesManager{
    static let transition = SlidInTransition()
    static var destination = "ToWishlistSegue"
    
    static let storyboard : UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
    static var rootView : UIViewController!
        
    
    static func showMenu(parent: UIViewController){
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "SideMenu") as? MenuController
            else{
                print("Error instantiating menu")
                return
        }
        menuViewController.parentView = parent
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = parent as? UIViewControllerTransitioningDelegate
        parent.present(menuViewController, animated: true)
    }
    
    static func transitionTo(parent: UIViewController, target: Scene){
        self.destination = target.rawValue
        parent.navigationController?.popToRootViewController(animated: true)
    }
    
    
}


