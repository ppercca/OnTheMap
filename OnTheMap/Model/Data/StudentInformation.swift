//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/5/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
}
