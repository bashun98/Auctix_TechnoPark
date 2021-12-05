//
//  TableModel.swift
//  Auctix
//
//  Created by Евгений Башун on 07.11.2021.
//

import FirebaseStorage

protocol TableModelDescription: AnyObject {
    var output: ListModelOutput? { get set }
    func loadProducts()
    func loadImage(with name: String, completion: @escaping (StorageReference) -> Void)
}

final class TableModel: TableModelDescription {
    private var exhibitionManager: ExhibitionManagerDescription = ExhibitionManager.shared
    private var imageLoader = ExhibitionsImageLoader.shared
    
    weak var output: ListModelOutput?
    
    public func loadProducts() {
        exhibitionManager.observeExhibitions()
        exhibitionManager.output = self
    }
    
//    public func loadImage(with name: String)  {
//        imageLoader.getReference(with: name) { [weak output] reference in
//            output?.didRecieveReference(reference)
//        }
//    }
    
    public func loadImage(with name: String, completion: @escaping (StorageReference) -> Void) {
        imageLoader.getReference(with: name) { reference in
            completion(reference)
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

