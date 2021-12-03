//
//  ListPresenter.swift
//  Auctix
//
//  Created by Евгений Башун on 30.11.2021.
//

import SDWebImage
import FirebaseStorage
import FirebaseStorageUI
import UIKit

protocol ListPresenterInput: AnyObject {
    var data: [Exhibition]? { get set }
    var reference: StorageReference? { get set }
    var pickerData: [String] { get }
    func getData()
    func didReceive(_ exhibitions: [Exhibition])
    func sortData(by text: String)
    func getReference(with name: String)
    func didRecieveReference(_ reference: StorageReference)
    var itemsCount: Int { get }
    func item(at index: Int) -> Exhibition
}

protocol ListTableOutput: AnyObject {
    
}

protocol ListViewOutPut: AnyObject {
    
}

protocol ListPresenterOutput: AnyObject {
    func reloadData()
}

class ListPresenter: ListPresenterInput {
    var reference: StorageReference?
    var itemsCount: Int {
        return data?.count ?? 0
    }
    let model: TableModelDescription!
    let view: ListPresenterOutput!
    var data: [Exhibition]?
    var pickerData: [String] {
        return ["Name","City","Country"]
    }
    
    required init(view: ListPresenterOutput, model: TableModelDescription) {
        self.view = view
        self.model = model
    }
        
    func getData() {
        model.loadProducts()
    }
    
    func didReceive(_ exhibitions: [Exhibition]) {
        self.data = exhibitions
        view.reloadData()
    }
    
    func sortData(by text: String) {
        switch text {
        case pickerData[0]:
            data?.sort(by: {$0.name < $1.name})
        case pickerData[1]:
            data?.sort(by: {$0.city < $1.city})
        case pickerData[2]:
            data?.sort(by: {$0.country < $1.country})
        default:
            return
        }
        view.reloadData()
    }
    
    func item(at index: Int) -> Exhibition {
        return data?[index] ?? Exhibition(name: "",
                                          city: "",
                                          country: "",
                                          startDate: "",
                                          expirationDate: "")
    }
    
    func getReference(with name: String) {
        model.loadImage(with: name)
    }
    
    func didRecieveReference(_ reference: StorageReference) {
        self.reference = reference
    }
    
    
}

