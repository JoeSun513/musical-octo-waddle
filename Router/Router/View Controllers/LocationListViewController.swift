//
//  LocationListViewController.swift
//  Router
//
//  Created by Joe Sun on 11/30/17.
//  Copyright © 2017 JoeSun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationListViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var sourceField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    var startLocationTuple: (textField: UITextField?, mapItem: MKMapItem?)
    var otherLocationTuples = [(textField: UITextField?, mapItem: MKMapItem)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
        startLocationTuple = (sourceField, nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherLocationTuples.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! LocationListTableViewCell
        cell.delegate = self
        return cell
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joined(separator: ", ")
    }
    
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        sourceField.resignFirstResponder()
    }
    
    @IBAction func startingSearch(_ sender: Any) {
        tableView.endEditing(true)
        
        let currentTextField = startLocationTuple.textField
        CLGeocoder().geocodeAddressString(currentTextField!.text!, completionHandler:
            {(placemarks: Optional<Array<CLPlacemark>>, error: Optional<Error>) -> () in
                if let placemarks = placemarks {
                    var addresses = [String]()
                    for placemark in placemarks {
                        addresses.append(self.formatAddressFromPlacemark(placemark: placemark))
                    }
                    self.performSegue(withIdentifier: "startSegue", sender: addresses)
                } else {
                    
                }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addresses = sender as? [String]
        if let dest = segue.destination as? SearchViewController {
            dest.addresses = addresses
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension LocationListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler:
            {(placemarks: Optional<Array<CLPlacemark>>, error: Optional<Error>) -> () in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    self.startLocationTuple.mapItem = MKMapItem(placemark:
                        MKPlacemark(coordinate: placemark.location!.coordinate,
                                    addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))
                    self.sourceField.text = self.formatAddressFromPlacemark(placemark: placemark)
                }
        })
        
    }
    
}
