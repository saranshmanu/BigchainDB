//
//  TableViewCell.swift
//  BigchainDB Web Socket
//
//  Created by Saransh Mittal on 05/03/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var blockID: UILabel!
    @IBOutlet weak var assetID: UILabel!
    @IBOutlet weak var transactionID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
