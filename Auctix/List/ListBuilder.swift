//
//  ListBuilder.swift
//  Auctix
//
//  Created by Евгений Башун on 30.11.2021.
//

import UIKit

protocol Builder {
    static func createListVC() -> UIViewController
}

class ListBuilder: Builder {
    static func createListVC() -> UIViewController {
        let model = TableModel()
        let view = ListViewController()
        let presenter = ListPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}
