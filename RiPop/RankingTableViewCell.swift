//
//  RankingTableViewCell.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 04.01.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userrecordLabel: UILabel!
    @IBOutlet var userNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
