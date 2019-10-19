//
//  UserbaseApi.swift
//  Pods
//
//  Created by Nikhil Kulkarni on 10/19/19.
//

import Foundation
import Alamofire

enum UserbaseApi {
    case register(id: String, password: String, firstName: String, lastName: String, developerMetadata: String)
    case login(id: String, password: String)
    case getFriends(token: String)
    case sendFriendRequest(token: String, id: String)
    case acceptFriendRequest(token: String, id: String)
    case getFriendRequests(token: String)
    case search(token: String, searchPrefix: String)
    case logout(token: String)
}

extension UserbaseApi : EndpointType {
    
    var path: String {
        switch self {
        case .register:
            return "/registerUser"
        case .login:
            return "/loginUser"
        case .getFriends:
            return "/fetchFriends"
        case .sendFriendRequest:
            return "/sendFriendRequest"
        case .acceptFriendRequest:
            return "/acceptFriendRequest"
        case .getFriendRequests:
            return "/getFriendRequests"
        case .search:
            return "/searchUsers"
        case .logout:
            return "/logout"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: [String : String] {
        switch self {
        case .register(let id, let password, let firstName, let lastName, let developerMetadata):
            return [
                "id": id,
                "password": password,
                "firstName": firstName,
                "lastName": lastName,
                "developerMetadata": developerMetadata
            ]
        case .login(let id, let password):
            return [
                "id": id,
                "password": password
            ]
        case .getFriends(let token):
            return ["token": token]
        case .sendFriendRequest(let token, let toId):
            return ["token": token, "id": toId]
        case .acceptFriendRequest(let token, let friendId):
            return ["token": token, "friendId": friendId]
        case .getFriendRequests(let token):
            return ["token": token]
        case .search(let token, let searchPrefix):
            return ["token": token, "prefix": searchPrefix]
        case .logout(let token):
            return ["token": token]
        }
    }
    
}
