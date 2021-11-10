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
}

final class TableProductModel: TableProductModelDescription {
    private var productManager: ProductManagerProtocol = ProductManager.shared
    
    weak var output: TableProductControllerInput?
    
    func loadProducts() {
        productManager.observeProducts()
        productManager.output = self
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
