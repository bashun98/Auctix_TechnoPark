//
//  ExhibitionsImageLoader.swift
//  Auctix
//
//  Created by Евгений Башун on 07.11.2021.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI


final class ExhibitionsImageLoader {
    let storage = Storage.storage().reference()
    static let shared = ExhibitionsImageLoader()
    
    func getReference(with name: String, completion: @escaping (StorageReference) -> Void) {
        let reference = storage.child(name)
        completion(reference)
    }
}
