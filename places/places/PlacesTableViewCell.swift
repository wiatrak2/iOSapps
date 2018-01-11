//
//  PlacesTableViewCell.swift
//  places
//
//  Created by Wojciech Pratkowiecki on 06.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var photoCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
