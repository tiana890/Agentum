//
//  OperationViewCell.swift
//  Agentum
//
//  Created by IMAC  on 09.08.15.
//
//

import UIKit

class OperationViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var numberOfFiles: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var verifyWayImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
