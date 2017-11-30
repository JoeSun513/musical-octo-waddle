//
//  LocationListTableViewCell.swift
//  Router
//
//  Created by Joe Sun on 11/30/17.
//  Copyright © 2017 JoeSun. All rights reserved.
//

import UIKit

class LocationListTableViewCell: UITableViewCell {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bringSubview(toFront: enterButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
