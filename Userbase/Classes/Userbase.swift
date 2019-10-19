//
//  Userbase.swift
//  Userbase
//
//  Created by Nikhil Kulkarni on 10/15/19.
//

import Foundation
import FirebaseAuth

private let invalidActionDomain = "UserbaseInvalidActionDomain"
private let userNotLoggedInError = NSError(
    domain: invalidActionDomain,
    code: 401,
    userInfo: [NSLocalizedDescriptionKey : "User is not logged in."])

public class Userbase {
    
    private static let client = UserbaseClient.sharedInstance
    
    public class func initWithLaunchOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let plist = Utils.getUserbasePlist() else {
            fatalError("Userbase.plist not found. Add property list to use Userbase SDK.")
        }
        
        guard let _ = plist["BASE_URL"] else {
            fatalError("Invalid Userbase.plist file. Base url not found.")
        }
    }
    
    public class func registerUser(id: String, password: String, firstName: String, lastName: String, developerMetadata: String, completion: @escaping (User?, Error?) -> Void) {
        client.registerUser(id: id, password: password, firstName: firstName, lastName: lastName, developerMetadata: developerMetadata, completion: completion)
    }
    
    public class func login(id: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        guard let _ = Auth.auth().currentUser else {
            client.login(id: id, password: password, completion: completion)
            return
        }
        
        let error = NSError(domain: invalidActionDomain, code: 401, userInfo: [NSLocalizedDescriptionKey : "User is already logged in"])
        completion(nil, error)
    }
    
    public class func getFriends(completion: @escaping ([Friend]?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, userNotLoggedInError)
            return
        }
        
        user.getIDToken(completion: { (idToken, error) in
            guard let token = idToken else {
                completion(nil, error)
                return
            }
            
            client.getFriends(token: token, completion: completion)
        })
    }
    
    public class func sendFriendRequest(to id: String, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(userNotLoggedInError)
            return
        }
        
        user.getIDToken { (idToken, error) in
            guard let token = idToken else {
                completion(error)
                return
            }
            
            client.sendFriendRequest(token: token, to: id, completion: completion)
        }
    }
    
    public class func acceptFriendRequest(from id: String, completion: @escaping (Friend?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, userNotLoggedInError)
            return
        }
        
        user.getIDToken { (idToken, error) in
            guard let token = idToken else {
                completion(nil, error)
                return
            }
            
            client.acceptFriendRequest(token: token, from: id, completion: completion)
        }
    }
    
    public class func getFriendRequests(completion: @escaping ([FriendRequest]?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, userNotLoggedInError)
            return
        }
        
        user.getIDToken { (idToken, error) in
            guard let token = idToken else {
                completion(nil, error)
                return
            }
            
            client.getFriendRequests(token: token, completion: completion)
        }
    }
    
    public class func searchUsers(searchPrefix: String, completion: @escaping ([Friend]?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, userNotLoggedInError)
            return
        }
        
        user.getIDToken { (idToken, error) in
            guard let token = idToken else {
                completion(nil, error)
                return
            }
            
            client.searchUsers(token: token, searchPrefix: searchPrefix, completion: completion)
        }
    }
    
}
