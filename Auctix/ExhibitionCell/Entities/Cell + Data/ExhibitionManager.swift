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
            Exhibition(titleImg: #imageLiteral(resourceName: "artist's_house_on_Kuznetsky"), title: "Kuznetsky Most", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", status: "new", city: "Moscow", country: "Russia"),
            Exhibition(titleImg: #imageLiteral(resourceName: "central_artist's_house"), title: "Park of Culture", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", status: "new", city: "Paris", country: "France"),
            Exhibition(titleImg: #imageLiteral(resourceName: "AccTabBar"), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd", status: "new", city: "Cairo", country: "Egypt")
        ]
    }

    
}
