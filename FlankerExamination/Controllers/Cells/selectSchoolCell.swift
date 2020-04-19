//
//  selectSchoolCell.swift
//  FlankerExamination
//
//  Created by Daniel James on 12/7/19.
//  Copyright © 2019 Dom.Inspiration. All rights reserved.
//

import UIKit

class selectSchoolCell: UITableViewCell {
    
    //This is a custom cell that we cast the table view cell to in the table view controller

    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var imageGo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
