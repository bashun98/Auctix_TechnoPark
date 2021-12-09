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
    func update(product: Product)
}

final class CollectionLikedModel: CollectionLikedModelDescription {

    private var productManager: ProductManagerProtocol = ProductManager.shared
    
    weak var output: AccountControllerInput?
    
    func loadProducts() {
        productManager.observeProducts()
        productManager.output = self
    }
    func update(product: Product) {
        productManager.update(product: product)
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
