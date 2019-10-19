//
//  NetworkRouter.swift
//  Userbase
//
//  Created by Nikhil Kulkarni on 10/19/19.
//

import Foundation
import Alamofire
import SwiftyJSON

private let routerDispatchQueueLabel = "com.userbase.Router"

class Router<Endpoint: EndpointType> {
    
    func run(endpoint: Endpoint, completion: @escaping (JSON?, Bool) -> Void) {
        let queue = DispatchQueue(label: routerDispatchQueueLabel, qos: .userInitiated)
        
        guard let plist = Utils.getUserbasePlist() else {
            fatalError("Userbase.plist not found. Add property list to use Userbase SDK.")
        }
        
        guard let baseUrl = plist["BASE_URL"] else {
            fatalError("Invalid Userbase.plist file. Base url not found.")
        }
        
        Alamofire.request(
            baseUrl + endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: JSONEncoding(options: .prettyPrinted),
            headers: nil).responseJSON(queue: queue, options: .allowFragments) { (data) in
                if (data.response?.statusCode != 200) {
                    completion(nil, false)
                    return
                }
                
                guard let data = data.result.value else {
                    completion(nil, false)
                    return
                }
                
                let jsonResponse = JSON(data)
                completion(jsonResponse, true)
        }
    }
    
}
