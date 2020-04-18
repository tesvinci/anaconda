//
//  CustomTableViewCell.swift
//  CoinAnaconda
//
//  Created by tesvinci on 7/14/18.
//  Copyright © 2018 tesvinci. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // tao bien ve nen
    
    
    @IBOutlet weak var lbTicker: UILabel!
    
    
    @IBOutlet weak var lbPrice: UILabel!
    
    
    @IBOutlet weak var lbCloseTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
