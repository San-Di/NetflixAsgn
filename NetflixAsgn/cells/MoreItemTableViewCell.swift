//
//  MoreItemTableViewCell.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/10/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit

class MoreItemTableViewCell: UITableViewCell {

    @IBOutlet weak var lblItemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
