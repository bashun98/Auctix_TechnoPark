//
//  TableModel.swift
//  Auctix
//
//  Created by Евгений Башун on 07.11.2021.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

protocol TableModelDescription: AnyObject {
    var output: ListPresenterInput? { get set }
    func loadProducts()
    func loadImage(with name: String)
}

final class TableModel: TableModelDescription {
    private var exhibitionManager: ExhibitionManagerProtocol = ExhibitionManager.shared
    private var imageLoader = ExhibitionsImageLoader.shared
    
    weak var output: ListPresenterInput?
    
    public func loadProducts() {
        exhibitionManager.observeExhibitions()
        exhibitionManager.output = self
    }
    
    public func loadImage(with name: String)  {
        imageLoader.getReference(with: name) { [weak output] reference in
            output?.didRecieveReference(reference)
        }
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

