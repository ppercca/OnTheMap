//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/7/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
