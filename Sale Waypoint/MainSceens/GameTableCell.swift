//
//  GameTableCell.swift
//  Sale Waypoint
//
//  Created by Joseph Peters on 5/20/20.
//  Copyright © 2020 Joseph Peters. All rights reserved.
//

import UIKit

class GameTableCell : UITableViewCell{
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gamePrice: UILabel!
    
    @IBOutlet weak var steamSale: UILabel!
    @IBOutlet weak var playstationSale: UILabel!
    @IBOutlet weak var nintendoSale: UILabel!
}
