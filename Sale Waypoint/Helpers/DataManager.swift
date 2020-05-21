//
//  DataManager.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/20/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
//

import Foundation
import Firebase

class DataManager{
    static var usersRef = Firestore.firestore().collection("Users")
    static var gamesRef = Firestore.firestore().collection("Games")
    static var userRef : DocumentReference?
    static var signedIn = false
}
