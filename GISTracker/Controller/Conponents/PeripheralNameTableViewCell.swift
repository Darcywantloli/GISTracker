//
//  PeripheralNameTableViewCell.swift
//  GISTracker
//
//  Created by imac-3282 on 2023/11/22.
//

import UIKit

class PeripheralNameTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "PeripheralNameTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
