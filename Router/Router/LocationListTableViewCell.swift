//
//  LocationListTableViewCell.swift
//  Router
//
//  Created by Joe Sun on 11/30/17.
//  Copyright © 2017 JoeSun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationListTableViewCell: UITableViewCell {

    @IBOutlet weak var searchBar: UITextField!
    var locationTuple: (textField: UITextField?, mapItem: MKMapItem?)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationTuple = (searchBar, nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func search(_ sender: Any) {
        self.endEditing(true)
        
        let currentTextField = locationTuple.textField
        CLGeocoder().geocodeAddressString(currentTextField!.text!, completionHandler:
            {(placemarks: Optional<Array<CLPlacemark>>, error: Optional<Error>) -> () in
                if let placemarks = placemarks {
                    
                } else {
                    
                }
        })
    }
    
}
