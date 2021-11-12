//
//  TableProductModel.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 10.11.2021.
//

import UIKit

protocol TableProductModelDescription: AnyObject {
    var output: TableProductControllerInput? { get set }
    func loadProducts()
    func update(product: Product)
}

final class TableProductModel: TableProductModelDescription {
    
    private var productManager: ProductManagerProtocol = ProductManager.shared
    
    weak var output: TableProductControllerInput?
    
    func loadProducts() {
        productManager.observeProducts()
        productManager.output = self
    }
    
    func update(product: Product) {
        productManager.update(product: product)
    }
}


extension TableProductModel: ProductManagerOutput {
    func didReceive(_ products: [Product]) {
        output?.didReceive(products)
    }

    func didFail(with error: Error) {
        // show error
    }
}
