//
//  User.swift
//  Userbase
//
//  Created by Nikhil Kulkarni on 10/15/19.
//

import Foundation
import SwiftyJSON

public class User: NSObject {
    
    public var id: String!
    public var password: String?
    public var firstName: String!
    public var lastName: String!
    public var developerMetadata: String?
    
    init(json: [String: JSON]) {
        self.id = json["id"]?.stringValue
        self.password = json["password"]?.stringValue
        self.firstName = json["firstName"]?.stringValue
        self.lastName = json["lastName"]?.stringValue
        self.developerMetadata = json["developerMetadata"]?.stringValue
    }

}
