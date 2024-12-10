//
//  listCell.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import UIKit
import CoreLocation
import MapKit

class listCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var plugLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var powerText: UILabel!
    @IBOutlet weak var operatorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()



    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
