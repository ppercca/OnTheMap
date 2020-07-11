//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/4/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
// MARK: - Location Methods
    
    func loadLocations(completion: @escaping () -> Void) {
        UdacityClient.getStudentLocation { (studentLocations, error) in
            StudentLocationModel.studentLocations = studentLocations
            completion()
        }
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        if (!UdacityClient.Auth.objectId.isEmpty) {
            let alertVC = UIAlertController(title: title, message: "You have already posted a location. Would you like to override it?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Override", style: .default, handler: {(alert: UIAlertAction!) in
                self.addLocation()
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        } else {
            addLocation()
        }
    }
    
    func addLocation() -> Void {
        let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
        addLocationViewController.modalPresentationStyle = .fullScreen
        self.present(addLocationViewController, animated: true, completion: nil)
    }
    
// MARK: - Open Media URL Method
    
    func openMediaURL(mediaURL: String) {
        if let url = URL(string: mediaURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                showFailureMessage(message: "The registered media URL is incorrect ", title: "Incorrect URL")
            }
        } else {
            showFailureMessage(message: "The registered media URL is incorrect ", title: "Incorrect URL")
        }
    }

// MARK: - Error Message Method
    
    func showFailureMessage(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

// MARK: - Logout Method
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityClient.logout { (success, error) in
            if success {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                loginViewController.modalPresentationStyle = .fullScreen
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
    }

}
