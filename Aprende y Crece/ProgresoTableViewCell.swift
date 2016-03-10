//
//  ProgresoTableViewCell.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 01/03/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class ProgresoTableViewCell: UITableViewCell {
    
    
    @IBOutlet var palomaOCruzImagen: UIImageView!
    @IBOutlet var fechaLabel: UILabel!
    @IBOutlet var ahorroLabel: UILabel!
    @IBOutlet var totalAhorroLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
