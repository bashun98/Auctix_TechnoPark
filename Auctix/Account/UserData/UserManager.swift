//
//  UserManager.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 14.11.2021.
//

import UIKit
import Firebase

protocol UserManagerProtocol {
    var output: UserManagerOutput? { get set }
    func observeUsers()
    func update(user: User)
}

protocol UserManagerOutput: AnyObject {
    func didReceive(_ users: [User])
    func didFail(with error: Error)
}

enum NetworkErrorUser: Error {
    case unexpected
}

class UserManager: UserManagerProtocol {
        
    var output: UserManagerOutput?
    static let shared: UserManagerProtocol = UserManager()
    private let database = Firestore.firestore()
    private let userConverter = UserConverter()
    
    private init(){}
    
    func observeUsers() {
        database.collection("users").addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                self?.output?.didFail(with: error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.output?.didFail(with: NetworkErrorProduct.unexpected)
                return
            }
            
            let user = documents.compactMap { self?.userConverter.user(from: $0) }
            self?.output?.didReceive(user)
        }
    }
    
    func update(user: User){
        database.collection("users").document(user.uid).updateData(userConverter.dict(from: user)) { [weak self] error in
            if error != nil {
                print("loh")
            } else {
                print("norm")
            }
        }
    }
}

private final class UserConverter {
    enum Key: String {
        case uid
        case id
        case name
        case phone
        case city
        case email
    }
    
    func user(from document: DocumentSnapshot) -> User? {
        guard let dict = document.data(),
              let uid = document.documentID as? String,
              let id = dict[Key.id.rawValue] as? String,
              let name = dict[Key.name.rawValue] as? String,
              let email = dict[Key.email.rawValue] as? String,
              let city = dict[Key.city.rawValue] as? String,
              let phone = dict[Key.phone.rawValue] as? String else {
                  return nil
              }

        return User(uid: uid,
                    id: id,
                    name: name,
                    phone: phone,
                    email: email,
                    city: city)
    }
    
    func dict(from user: User) -> [String: Any] {
            var data: [String: Any] = [:]
            
            data[Key.name.rawValue] = user.name
            data[Key.phone.rawValue] = user.phone
            data[Key.email.rawValue] = user.email
            data[Key.city.rawValue] = user.city
    
            return data
        }
}

