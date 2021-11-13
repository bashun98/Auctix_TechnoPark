//
//  GoodsManager.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit
import Firebase

protocol ProductManagerProtocol {
    var output: ProductManagerOutput? { get set }
    func observeProducts()
    func update(product: Product)
}

protocol ProductManagerOutput: AnyObject {
    func didReceive(_ products: [Product])
    func didFail(with error: Error)
}

enum NetworkErrorProduct: Error {
    case unexpected
}

class ProductManager: ProductManagerProtocol {
    var output: ProductManagerOutput?
    static let shared: ProductManagerProtocol = ProductManager()
    private let database = Firestore.firestore()
    private let productConverter = ProductConverter()
    
    private init(){}
    
    func observeProducts() {
        database.collection("products").addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                self?.output?.didFail(with: error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.output?.didFail(with: NetworkErrorProduct.unexpected)
                return
            }
            
            let product = documents.compactMap { self?.productConverter.product(from: $0) }
            self?.output?.didReceive(product)
        }
    }
    
    func update(product: Product){
        database.collection("products").document(product.id).updateData(productConverter.dict(from: product)) { [weak self] error in
            if error != nil {
                
            } else {
                
            }
        }
    }
}

private final class ProductConverter {
    enum Key: String {
        case id
        case name
        case currentPrice
        case startingPrice
        case idExhibition
        case currentIdClient
        case idClient
    }
    
    func product(from document: DocumentSnapshot) -> Product? {
        guard let dict = document.data(),
              let id = dict[Key.id.rawValue] as? String,
              let name = dict[Key.name.rawValue] as? String,
              let currentPrice = dict[Key.currentPrice.rawValue] as? Int,
              let startingPrice = dict[Key.startingPrice.rawValue] as? Int,
              let idExhibition = dict[Key.idExhibition.rawValue] as? String,
              let currentIdClient = dict[Key.currentIdClient.rawValue] as? String,
              let idClient = dict[Key.idClient.rawValue] as? [String] else {
                  return nil
              }

        return Product(id: id,
                       name: name,
                       currentPrice: currentPrice,
                       startingPrice: startingPrice,
                       idExhibition: idExhibition,
                       currentIdClient: currentIdClient,
                       idClient: idClient)
    }
    
    func dict(from product: Product) -> [String: Any] {
            var data: [String: Any] = [:]
            
            data[Key.currentPrice.rawValue] = product.currentPrice
            data[Key.idClient.rawValue] = product.idClient
            data[Key.currentIdClient.rawValue] = product.currentIdClient
    
            return data
        }
}

