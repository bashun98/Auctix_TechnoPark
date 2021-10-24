//
//  GoodsManager.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit

protocol ProductManagerProtokol{
    func loadExhibition()->[Product]
}

class ProductManager: ProductManagerProtokol {
    
    static let shared: ProductManagerProtokol = ProductManager()

    private init(){}

    func loadExhibition() -> [Product] {
        return [
            Product(productImg:  #imageLiteral(resourceName: "artist's_house_on_Kuznetsky"), title: "Kuznetsky Most", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", exhibition: "", status: "new", cost: "10"),
//            Product(titleImg:  imageLiteral(resourceName: "central_artist's_house"), title: "Park of Culture", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", status: "new"),
//            Product(titleImg:  imageLiteral(resourceName: "AccTabBar"), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", status: "new")
        ]
    
    }

    
}
