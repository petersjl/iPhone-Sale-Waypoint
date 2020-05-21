//
//  WishlistController.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/18/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class WishlistController : UITableViewController {
    var authListenerHandle : AuthStateDidChangeListenerHandle!
    var gamesListener : ListenerRegistration!
    var userListener : ListenerRegistration!
    
    var games = [DocumentReference]()
    var gamesSnapshots = [DocumentSnapshot]()
    let cellIdentifier = "GameCell"
    var reloading = false
    var loadedOnce = false
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "☰", style: .plain, target: self, action: #selector(menu))
    navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
        tableView.backgroundColor = UIColor(displayP3Red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)
    }
    
    @objc func menu(){
        ScenesManager.showMenu(parent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedOnce = false
        authListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if Auth.auth().currentUser == nil{
                ScenesManager.destination = Scene.wishlist.rawValue
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        userListener = DataManager.userRef?.addSnapshotListener({ (document, error) in
            if let error = error{
                print("Error setting user listener \n \(error)")
                return
            }
            self.games = (document?.get("wishlist") as! [DocumentReference])
            print(self.games)
            if !self.reloading{self.reloadGames()}
            self.loadedOnce = true
        })
        gamesListener = DataManager.gamesRef.addSnapshotListener({ (query, error) in
            if let error = error{
                print("Error in game listener \n \(error)")
                return
            }
            if self.loadedOnce{
                if !self.reloading{self.reloadGames()}
            }
        })
    }
    
    func reloadGames(){
        reloading = true
        print("Reloading games")
        gamesSnapshots.removeAll()
        for game in games{
            game.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error getting game snapshot \n \(error)")
                    return
                }
                print(snapshot!.data())
                self.gamesSnapshots.append(snapshot!)
                if self.games.count == self.gamesSnapshots.count{
                    self.tableView.reloadData()
                    self.reloading = false
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesSnapshots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GameTableCell
        print("Index path: \(indexPath.row)")
        print("Arraysize: \(gamesSnapshots.count)")
        cell.gameTitle.text = (gamesSnapshots[indexPath.row].get("title") as! String)
        cell.gamePrice.text = "$" + (gamesSnapshots[indexPath.row].get("price") as! NSNumber).stringValue
        cell.playstationSale.text = (gamesSnapshots[indexPath.row].get("psSale") as! NSNumber).stringValue + "%"
        cell.steamSale.text = (gamesSnapshots[indexPath.row].get("steamSale") as! NSNumber).stringValue + "%"
        cell.nintendoSale.text = (gamesSnapshots[indexPath.row].get("nintendoSale") as! NSNumber).stringValue + "%"
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gamesListener.remove()
        userListener.remove()
    }
    
    
}

extension WishlistController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ScenesManager.transition.isPresenting = true
        return ScenesManager.transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ScenesManager.transition.isPresenting = false
        return ScenesManager.transition
    }
}
