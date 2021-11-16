//
//  CollectionLikedModel.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 15.11.2021.
//

import UIKit

protocol CollectionLikedModelDescription: AnyObject {
    var output: AccountControllerInput? { get set }
    func loadProducts()
}

final class CollectionLikedModel: CollectionLikedModelDescription {

    private var productManager: ProductManagerProtocol = ProductManager.shared
    
    weak var output: AccountControllerInput?
    
    func loadProducts() {
        productManager.observeProducts()
        productManager.output = self
    }
}


extension CollectionLikedModel: ProductManagerOutput {
    func didReceive(_ products: [Product]) {
        output?.didReceive(products)
    }

    func didFail(with error: Error) {
        // show error
    }
}
