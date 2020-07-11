//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/5/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let code: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? { return error } 
}
