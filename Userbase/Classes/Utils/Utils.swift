//
//  Utils.swift
//  Userbase
//
//  Created by Nikhil Kulkarni on 10/19/19.
//

import Foundation

class Utils {
    
    public static func getUserbasePlist() -> [String : String]? {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        let plistPath: String? = Bundle.main.path(forResource: "Userbase-Info", ofType: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {
            let plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String : String]
            return plistData
        } catch {
            return nil
        }
    }
    
}
