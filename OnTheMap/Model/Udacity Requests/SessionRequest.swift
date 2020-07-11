//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/5/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

struct Udacity: Codable {
    let username: String
    let password: String
}

struct SessionRequest: Codable {
    let udacity: Udacity
}
