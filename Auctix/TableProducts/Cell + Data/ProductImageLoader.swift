//
//  ProductImageLoader.swift
//  Auctix
//
//  Created by Евгений Башун on 12.11.2021.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

final class ProductImageLoader {
    let storage = Storage.storage().reference()
    static let shared = ProductImageLoader()
    
    func getReference(with name: String, completion: @escaping (StorageReference) -> Void) {
        let reference = storage.child(name)
        completion(reference)
    }
}
