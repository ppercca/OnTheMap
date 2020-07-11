//
//  LocationsMapViewController.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/6/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit
import MapKit

class LocationsMapViewController: UIViewController, MKMapViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
// MARK: - Student Location Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading(true)
        loadLocations {
            self.loading(false)
            self.createPointAnnotations()
        }
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        StudentLocationModel.studentLocations = []
        createPointAnnotations()
        loading(true)
        loadLocations {
            self.loading(false)
            self.createPointAnnotations()
        }
    }
    
    func loading(_ value: Bool) {
        if value {
            activityIndicator.startAnimating()
            view.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            self.view.alpha = 1
        }
    }
    
// MARK: - Map Methods
    
    func createPointAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        for studentLocation in StudentLocationModel.studentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
            annotation.title = studentLocation.firstName + " " + studentLocation.lastName
            annotation.subtitle = studentLocation.mediaURL
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
             pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
             pinView!.canShowCallout = true
             pinView!.pinTintColor = .red
             pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
         }
         else {
             pinView!.annotation = annotation
         }

         return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = view.annotation?.subtitle! {
                openMediaURL(mediaURL: mediaURL)
            }
        }
    }
    
}
