//
//  OperationFormCell.swift
//  Agentum
//
//  Created by Agentum on 04.09.15.
//
//

import UIKit

class OperationFormCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(self.selected == true && selected == true){
            self.checkImage.image = UIImage(named: "checked")
        // Configure the view for the selected state
        } else {
            self.checkImage.image = UIImage(named: "unchecked")
        }
    }
    

}
