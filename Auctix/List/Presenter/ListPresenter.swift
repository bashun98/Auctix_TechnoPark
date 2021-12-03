//
//  ListPresenter.swift
//  Auctix
//
//  Created by Евгений Башун on 30.11.2021.
//

protocol ListPresenterProtocol: AnyObject {
    init(view: ListViewControllerProtocol, model: TableModelDescription)
    func getData()
    //var data: [Exhibition]? { get set }
}

protocol ListViewControllerProtocol: AnyObject {
    func setData(_ data: [Exhibition])
}

protocol ListPresenterInput: AnyObject {
    
}

class ListPresenter: ListPresenterProtocol {
    let model: TableModelDescription!
    let view: ListViewControllerProtocol!
    
    required init(view: ListViewControllerProtocol, model: TableModelDescription) {
        self.view = view
        self.model = model
    }
    
    func getData() {
        model.loadProducts()
    }
}

extension ListPresenter: TableModelOutput {
    func didReceive(_ exhibitions: [Exhibition]) {
        view.setData(exhibitions)
    }
}
