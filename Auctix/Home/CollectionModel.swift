//
//  CollectionModel.swift
//  Auctix
//
//  Created by Евгений Башун on 07.11.2021.
//

import UIKit

protocol CollectionModelDescription: AnyObject {
    var output: HomeViewControllerInput? { get set }
    func loadProducts()
}

final class CollectionModel: CollectionModelDescription {
    private var exhibitionManager: ExhibitionManagerProtocol = ExhibitionManager.shared
    
    weak var output: HomeViewControllerInput?
    
    func loadProducts() {
        exhibitionManager.observeExhibitions()
        exhibitionManager.output = self
    }
}


extension CollectionModel: ExhibitionManagerOutput {
    func didReceive(_ exhibitions: [Exhibition]) {
        output?.didReceive(exhibitions)
    }

    func didFail(with error: Error) {
        // show error
    }
}

