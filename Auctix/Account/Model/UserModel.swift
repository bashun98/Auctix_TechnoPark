//
//  UserModel.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 14.11.2021.
//


import UIKit

protocol UserModelDescription: AnyObject {
    var output: UserControllerInput? { get set }
    func loadUsers()
    func update(user: User)
}

final class UserModel: UserModelDescription {
    
    private var userManager: UserManagerProtocol = UserManager.shared
    
    weak var output: UserControllerInput?
    
    func loadUsers() {
        userManager.observeUsers()
        userManager.output = self
    }
    
    func update(user: User) {
        userManager.update(user: user)
    }
}


extension UserModel: UserManagerOutput {
    func didReceive(_ users: [User]) {
        output?.didReceive(users)
    }

    func didFail(with error: Error) {
        // show error
    }
}
