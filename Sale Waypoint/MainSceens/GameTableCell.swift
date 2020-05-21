//
//  GameTableCell.swift
//  Sale Waypoint
//
//  Created by CSSE Department on 5/20/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

import UIKit

class GameTableCell : UITableViewCell{
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gamePrice: UILabel!
    
    @IBOutlet weak var steamSale: UILabel!
    @IBOutlet weak var playstationSale: UILabel!
    @IBOutlet weak var nintendoSale: UILabel!
}
