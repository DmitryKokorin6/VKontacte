//
//  APIManager.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 06.10.2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func fetchFriends(completion: @escaping (Result<FriendsRequest, Error>) -> Void) {
       let path = "/method/friends.get"
       let queryItems = [
           URLQueryItem(name: "access_token", value: Session.instance.token),
           URLQueryItem(name: "user_id", value: Session.instance.userId),
           URLQueryItem(name: "fields", value: "nickname"),
           URLQueryItem(name: "count", value: "300"),
           URLQueryItem(name: "order", value: "hints"),
           URLQueryItem(name: "v", value: "5.81")
       ]
       
       APIClient.shared.fetch(from: path, queryItems: queryItems) { (result: Result<FriendsRequest, Error>) in
           switch result {
           case .success(let friends):
               completion(.success(friends))
           case .failure(let error):
               completion(.failure(error))
           }
       }

   }
    
    func fetchGroups(completion: @escaping (Result<GroupsRequest, Error>) -> Void) {
        let path = "/method/groups.get"
        let queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "user_id", value: Session.instance.userId),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.81")
        ]
        
        APIClient.shared.fetch(from: path, queryItems: queryItems) { (result: (Result<GroupsRequest, Error>)) in
            switch result {
            case .success(let groups):
                completion(.success(groups))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFotos(completion: @escaping (Result<FotosRequest, Error>) -> Void) {
        let path = "/method/photos.get"
        let queryItems = [
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "v", value: "5.81"),
            URLQueryItem(name: "access_token", value: Session.instance.token)
        ]
        
        APIClient.shared.fetch(from: path, queryItems: queryItems) { (result: (Result<FotosRequest, Error>)) in
            switch result {
            case .success(let fotos):
                completion(.success(fotos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearchGroups(completion: @escaping ((Result<SearchGroupsRequest, Error>) -> Void)) {
        let path = "/method/groups.search"
        let queryItems = [
            URLQueryItem(name: "q", value: "GeekBrains"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.81")
        ]
        
        APIClient.shared.fetch(from: path, queryItems: queryItems) { (result: (Result<SearchGroupsRequest, Error>)) in
            switch result {
            case .success(let searchGroups):
                completion(.success(searchGroups))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
