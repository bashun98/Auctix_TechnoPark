//
//  GoodsManager.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit

protocol ProductManagerProtokol{
    func loadProducts()->[Product]
}

class ProductManager: ProductManagerProtokol {
    
    static let shared: ProductManagerProtokol = ProductManager()

    private init(){}

    func loadProducts() -> [Product] {
        return [
            Product(productImg:  #imageLiteral(resourceName: "ListTabBar"), title: "Kuznetsky Most", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", exhibition: "", status: "new", cost: "10"),
            Product(productImg:  #imageLiteral(resourceName: "central_artist's_house"), title: "Kuznetsky Most", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", exhibition: "", status: "new", cost: "10"),
            Product(productImg:  #imageLiteral(resourceName: "artist's_house_on_Kuznetsky"), title: "Kuznetsky Most", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", exhibition: "", status: "new", cost: "10"),
            Product(productImg:  #imageLiteral(resourceName: "Search"), title: "Kuznetsky Most", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", exhibition: "", status: "new", cost: "10"),
        ]
    
    }

    
}
