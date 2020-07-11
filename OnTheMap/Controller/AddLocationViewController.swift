//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/5/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: OnTheMapTextField!
    @IBOutlet weak var linkTextField: OnTheMapTextField!
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: - Location Information Processing Methods
    
    @IBAction func findLocation(_ sender: Any) {
        guard let location = locationTextField.text else { return }
        guard let link = linkTextField.text else { return }
        
        if location.isEmpty {
            showFailureMessage(message: "Please, introduce the location", title: "Missing Location")
            return
        }
        if link.isEmpty {
            showFailureMessage(message: "Please, introduce the link", title: "Missing Link")
            return
        }
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            showFailureMessage(message: "The location wasn't found ", title: "Incorrect Location")
        } else {
            var location: CLLocation?

            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                let coordinate = location.coordinate
                let mapViewController = self.storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                mapViewController.location = locationTextField.text
                mapViewController.mediaURL = linkTextField.text
                mapViewController.latitude = coordinate.latitude
                mapViewController.longitude = coordinate.longitude
                self.navigationController!.pushViewController(mapViewController, animated: true)
                
            } else {
                print( "No Matching Location Found")
            }
        }
    }
}
