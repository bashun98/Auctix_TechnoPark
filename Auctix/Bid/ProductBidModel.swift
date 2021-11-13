//
//  ProductBidModel.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 11.11.2021.
//

import UIKit

protocol BidTableProductModelDescription: AnyObject {
    var output: BidTableProductControllerInput? { get set }
    func loadProducts()
    func update(product: Product)
}

final class BidTableProductModel: BidTableProductModelDescription {
    
    private var productManager: ProductManagerProtocol = ProductManager.shared
    
    weak var output: BidTableProductControllerInput?
    
    func loadProducts() {
        productManager.observeProducts()
        productManager.output = self
    }
    
    func update(product: Product) {
        productManager.update(product: product)
    }
}


extension BidTableProductModel: ProductManagerOutput {
    func didReceive(_ products: [Product]) {
        output?.didReceive(products)
    }

    func didFail(with error: Error) {
        // show error
    }
}
