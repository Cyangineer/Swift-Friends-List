//
//  UserViewCell.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/11/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageViewX!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
