//
//  GamesListController.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/20/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
//

import UIKit
import Firebase

class GamesListController : UITableViewController {
    var authListenerHandle : AuthStateDidChangeListenerHandle!
    var gamesListener : ListenerRegistration!
    var games = [QueryDocumentSnapshot]()
    
    let cellIdentifier = "GameCell"
    let detailSegue = "GameDetail"
    
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "☰", style: .plain, target: self, action: #selector(menu))
    navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(displayP3Red: 220/255, green: 26/255, blue: 0, alpha: 1)
        tableView.backgroundColor = UIColor(displayP3Red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)
    }
    
    @objc func menu(){
        ScenesManager.showMenu(parent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil{
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        authListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if Auth.auth().currentUser == nil{
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        startListening()
    }
    
    func startListening(){
        let query = DataManager.gamesRef.order(by: "title", descending: true).limit(to: 50)
        gamesListener = query.addSnapshotListener { (querySnapshot, error) in
            self.games.removeAll()
            if let querySnapshot = querySnapshot {
                querySnapshot.documents.forEach { (documentSnapshot) in
                    self.games.append(documentSnapshot)
                }
                self.tableView.reloadData()
            }else{
                print("Error getting movie quotes \(error!)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gamesListener.remove()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GameTableCell
        cell.gameTitle!.text = (games[indexPath.row].get("title") as! String)
        cell.gamePrice!.text = "$" + (games[indexPath.row].get("price") as! NSNumber).stringValue
        cell.steamSale!.text = (games[indexPath.row].get("steamSale") as! NSNumber).stringValue + "%"
        cell.playstationSale!.text = (games[indexPath.row].get("psSale") as! NSNumber).stringValue + "%"
        cell.nintendoSale!.text = (games[indexPath.row].get("nintendoSale") as! NSNumber).stringValue + "%"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegue {
            if let indexPath = tableView.indexPathForSelectedRow{
                let dest = segue.destination as! GameDetailController
                dest.game = games[indexPath.row].reference
            }
        }
    }
}

extension GamesListController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ScenesManager.transition.isPresenting = true
        return ScenesManager.transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ScenesManager.transition.isPresenting = false
        return ScenesManager.transition
    }
}
