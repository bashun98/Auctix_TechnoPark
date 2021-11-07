//
//  TableModel.swift
//  Auctix
//
//  Created by Евгений Башун on 07.11.2021.
//

import UIKit

protocol TableModelDescription: AnyObject {
    var output: ListViewControllerInput? { get set }
    func loadProducts()
}

final class TableModel: TableModelDescription {
    private var exhibitionManager: ExhibitionManagerProtocol = ExhibitionManager.shared
    
    weak var output: ListViewControllerInput?
    
    func loadProducts() {
        exhibitionManager.observeExhibitions()
        exhibitionManager.output = self
    }
}


extension TableModel: ExhibitionManagerOutput {
    func didReceive(_ exhibitions: [Exhibition]) {
        output?.didReceive(exhibitions)
    }

    func didFail(with error: Error) {
        // show error
    }
}

