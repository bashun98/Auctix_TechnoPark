//
//  UserImageUploader.swift
//  Auctix
//
//  Created by Евгений Башун on 24.11.2021.
//

import FirebaseStorage
import FirebaseStorageUI


final class UserImageUploader {
    let storage = Storage.storage().reference()
    static let shared = UserImageUploader()
    
//    func getReference(with name: String, completion: @escaping (StorageReference) -> Void) {
//        let reference = storage.child(name)
//        completion(reference)
//    }
    func uploadUserImage(with name: String) {
        let reference = storage.child("UsersPhoto/\(name)")
     //   let uploadRask = reference.putData(<#T##uploadData: Data##Data#>)
    }
}
