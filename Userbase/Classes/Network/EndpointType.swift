//
//  EndpointType.swift
//  Userbase
//
//  Created by Nikhil Kulkarni on 10/19/19.
//

import Foundation
import Alamofire

protocol EndpointType {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String : String] { get }
}
