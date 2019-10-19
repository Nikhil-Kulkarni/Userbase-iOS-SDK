//
//  Friend.swift
//  Userbase
//
//  Created by Nikhil Kulkarni on 10/15/19.
//

import Foundation
import SwiftyJSON

public class Friend: NSObject {
    
    public var id: String!
    public var firstName: String!
    public var lastName: String!
    public var developerMetadata: String?
    
    init(json: [String: JSON]) {
        self.id = json["id"]?.stringValue
        self.firstName = json["firstName"]?.stringValue
        self.lastName = json["lastName"]?.stringValue
        self.developerMetadata = json["developerMetadata"]?.stringValue
    }
    
}
