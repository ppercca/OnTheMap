//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/4/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit

class LocationlistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocations {
            self.tableView.reloadData()
        }
    }

    @IBAction func refreshLocations(_ sender: Any) {
        StudentLocationModel.studentLocations = []
        self.tableView.reloadData()
        loading(true)
        loadLocations {
            self.loading(false)
            self.tableView.reloadData()
        }
    }
    
    func loading(_ value: Bool) {
        if value {
            activityIndicator.startAnimating()
            self.view.alpha = 0.8
        } else {
            self.view.alpha = 1
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - LocationlistViewController Delegate Methods

extension LocationlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationViewCell")!
        let location = StudentLocationModel.studentLocations[indexPath.row]
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = StudentLocationModel.studentLocations[indexPath.row]
        openMediaURL(mediaURL: location.mediaURL)
    }
    
}
