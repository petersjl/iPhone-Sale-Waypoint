//
//  AddGameController.swift
//  Sale Waypoint
//
//  Created by CSSE Department on 5/21/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

import UIKit

class AddGameController : UIViewController {
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "☰", style: .plain, target: self, action: #selector(menu))
    navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(displayP3Red: 220/255, green: 26/255, blue: 0, alpha: 1)
      
    }
    @objc func menu(){
        ScenesManager.showMenu(parent: self)
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
