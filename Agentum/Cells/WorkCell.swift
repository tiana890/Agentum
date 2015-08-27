//
//  WorkCell.swift
//  Agentum
//
//  Created by IMAC  on 07.08.15.
//
//

import UIKit

class WorkCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var numberOfOperations: UILabel!
    @IBOutlet var numberOfFiles: UILabel!
    
    @IBOutlet weak var objectName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
