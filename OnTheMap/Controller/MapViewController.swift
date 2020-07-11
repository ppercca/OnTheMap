//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/5/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var location: String!
    var mediaURL: String!
    var latitude:  Double!
    var longitude:  Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let cordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: cordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cordinate
        annotation.title = location
        mapView.addAnnotation(annotation)
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
    
// MARK: - Map Method
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         let reuseId = "pin"

         var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

         if pinView == nil {
              pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
              pinView!.canShowCallout = true
              pinView!.pinTintColor = .red
          }
          else {
              pinView!.annotation = annotation
          }

          return pinView
     }
    
// MARK: - Save and Update Student Information Methods
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        loading(true)
        if (UdacityClient.Auth.objectId.isEmpty) {
            UdacityClient.postStudentLocation(mapString: self.location, mediaURL: self.mediaURL, latitude: self.latitude, longitude: self.longitude, completion: self.handlerSaveStudentLocationResponse(success:error:))
        } else {
            UdacityClient.putStudentLocation(mapString: self.location, mediaURL: self.mediaURL, latitude: self.latitude, longitude: self.longitude, completion: self.handlerSaveStudentLocationResponse(success:error:))
        }
    }
    
    func handlerSaveStudentLocationResponse(success: Bool, error: Error?) -> Void {
        loading(false)
        if success {
            let onTheMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnTheMapViewController") as! UITabBarController
            onTheMapViewController.modalPresentationStyle = .fullScreen
            present(onTheMapViewController, animated: true, completion: nil)
        } else {
            showFailureMessage(message: error?.localizedDescription ?? "", title: "Error")
        }
    }
}
