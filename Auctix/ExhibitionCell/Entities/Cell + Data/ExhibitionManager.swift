//
//  ExhibitionManager.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

protocol ExhibitionManagerProtokol{
    func loadExhibition()->[Exhibition]
}

class ExhibitionManager: ExhibitionManagerProtokol {
    
    static let shared: ExhibitionManagerProtokol = ExhibitionManager()

    private init(){}

    func loadExhibition() -> [Exhibition] {
        return [
            Exhibition(titleImg: #imageLiteral(resourceName: "Search"), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", status: "new"),
            Exhibition(titleImg: #imageLiteral(resourceName: "BidTabBar"), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", status: "old"),
            Exhibition(titleImg: #imageLiteral(resourceName: "AccTabBar"), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", status: "new")
        ]
    }

    
}
