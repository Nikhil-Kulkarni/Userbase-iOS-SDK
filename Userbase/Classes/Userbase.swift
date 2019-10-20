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
            fatalError("Userbase-Info.plist not found. Add property list to use Userbase SDK.")
        }
        
        guard let _ = plist["BASE_URL"] else {
            fatalError("Invalid Userbase.plist file. Base url not found.")
        }
        
    }
    
    /**
     Create and register a new user
     - parameters:
        - id: A unique identifier for the user
        - password: A password
        - firstName: First name of the user
        - lastName: Last name of the user
        - developerMetadata: Any metadata associated with this user stored in string format
        - completion:A completion handler to process the newly created user or an error
     */
    public class func registerUser(id: String, password: String, firstName: String, lastName: String, developerMetadata: String, completion: @escaping (User?, Error?) -> Void) {
        client.registerUser(id: id, password: password, firstName: firstName, lastName: lastName, developerMetadata: developerMetadata, completion: completion)
    }
    
    /**
     Login the user
     - parameters:
        - id: The user's unique identifier
        - password: The password
        - completion: A completion handler to process the logged in user or an error
     */
    public class func login(id: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        guard let _ = Auth.auth().currentUser else {
            client.login(id: id, password: password, completion: completion)
            return
        }
        
        let error = NSError(domain: invalidActionDomain, code: 401, userInfo: [NSLocalizedDescriptionKey : "User is already logged in"])
        completion(nil, error)
    }
    
    /**
     Fetch all the friends of the current in user.
     - Attention: The user must be logged in to call this method
     - parameters:
        - completion: A completion handler to process a list of `Friend` or an error
     */
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
    
    /**
     Send a friending request to a user
     - Attention: The user must be logged in to call this method
     - parameters:
        - id: The unique identifier of the user to send a friending request to
        - completion: A completion handler to process an error
     */
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
    
    /**
    Accept a friend request
     - Attention: The user must be logged in to call this method
     - parameters:
        - id: The unique identifier of the user from whom the friend request is being accepted
        - completion: A completion handler to process the new `Friend` or an error
     */
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
    
    /**
     Fetches friend requests for current user
     - Attention: The user must be logged in to call this method
     - parameters:
        - completion: A completion handler to process a list of `FriendRequest` or an error
     */
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
    
    /**
     Search user in the system be a prefix. The prefix can be a name or an id
     - Attention: The user must be logged in to call this method
     - parameters:
        - searchPrefix: The text to search
        - completion: A completion handler to process a list of users or an error
     */
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
    
    /**
     Log out the user
     - Attention: The user must be logged in to call this method
     - parameters:
        - completion: A completion handler to process an error
     */
    public class func logout(completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        user.getIDToken { (idToken, error) in
            guard let token = idToken else {
                completion(nil)
                return
            }
            
            client.logout(token: token, completion: completion)
        }
        
    }
    
}
