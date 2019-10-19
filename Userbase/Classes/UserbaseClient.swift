//
//  UserbaseClient.swift
//  Userbase
//
//  Created by Nikhil Kulkarni on 10/15/19.
//

import Foundation

private let somethingWentWrongError = NSError(
    domain: "UserbaseHTTPError",
    code: 400,
    userInfo: [NSLocalizedDescriptionKey: "Something went wrong. Please try again"])

class UserbaseClient: NSObject {
    
    static let sharedInstance = UserbaseClient()
    private let router = Router<UserbaseApi>()
    
    public func registerUser(id: String, password: String, firstName: String, lastName: String, developerMetadata: String, completion: @escaping (User?, Error?) -> Void) {
        let endpoint = UserbaseApi.register(id: id, password: password, firstName: firstName, lastName: lastName, developerMetadata: developerMetadata)
        router.run(endpoint: endpoint) { (json, success) in
            if (!success) {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            let user = User(json: jsonResponse)
            completion(user, nil)
        }
    }
    
    public func login(id: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        let endpoint = UserbaseApi.login(id: id, password: password)
        router.run(endpoint: endpoint) { (json, success) in
            if (!success) {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            let user = User(json: jsonResponse)
            completion(user, nil)
        }
    }
    
    public func getFriends(token: String, completion: @escaping ([Friend]?, Error?) -> Void) {
        let endpoint = UserbaseApi.getFriends(token: token)
        router.run(endpoint: endpoint) { (json, success) in
            if (!success) {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let friendArray = jsonResponse["friends"]?.arrayValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            var friends: [Friend] = []
            for friend in friendArray {
                friends.append(Friend(json: friend.dictionaryValue))
            }
            completion(friends, nil)
        }
    }
    
    public func sendFriendRequest(token: String, to id: String, completion: @escaping (Error?) -> Void) {
        let endpoint = UserbaseApi.sendFriendRequest(token: token, id: id)
        router.run(endpoint: endpoint) { (json, success) in
            if (!success) {
                completion(somethingWentWrongError)
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(somethingWentWrongError)
                return
            }
            
            let didSucceed = jsonResponse["success"]?.boolValue
            if (didSucceed == true) {
                completion(nil)
            } else {
                let error = NSError(domain: "UserbaseRequestFailedError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
                completion(error)
            }
        }
    }
    
    public func acceptFriendRequest(token: String, from id: String, completion: @escaping (Friend?, Error?) -> Void) {
        let endpoint = UserbaseApi.acceptFriendRequest(token: token, id: id)
        router.run(endpoint: endpoint) { (json, success) in
            if (!success) {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            let friend = Friend(json: jsonResponse)
            completion(friend, nil)
        }
    }
    
    public func getFriendRequests(token: String, completion: @escaping ([FriendRequest]?, Error?) -> Void) {
        let endpoint = UserbaseApi.getFriendRequests(token: token)
        router.run(endpoint: endpoint) { (json, success) in
            if (!success) {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let friendRequestsArray = jsonResponse["requests"]?.arrayValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            var requests: [FriendRequest] = []
            for request in friendRequestsArray {
                requests.append(FriendRequest(json: request.dictionaryValue))
            }
            completion(requests, nil)
        }
    }
    
    public func searchUsers(token: String, searchPrefix: String, completion: @escaping ([Friend]?, Error?) -> Void) {
        let endpoint = UserbaseApi.search(token: token, searchPrefix: searchPrefix)
        router.run(endpoint: endpoint) { (json, success) in
            if (!success) {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            guard let usersArray = jsonResponse["users"]?.arrayValue else {
                completion(nil, somethingWentWrongError)
                return
            }
            
            var users: [Friend] = []
            for user in usersArray {
                users.append(Friend(json: user.dictionaryValue))
            }
            completion(users, nil)
        }
    }
    
    public func logout(token: String, completion: @escaping (Error?) -> Void) {
        let endpoint = UserbaseApi.logout(token: token)
        router.run(endpoint: endpoint) { (json, success) in
            if (!success) {
                completion(somethingWentWrongError)
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(somethingWentWrongError)
                return
            }
            
            let didSucceed = jsonResponse["success"]?.boolValue
            if (didSucceed == true) {
                completion(nil)
            } else {
                let error = NSError(domain: "UserbaseRequestFailedError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
                completion(error)
            }
        }
    }
    
}
