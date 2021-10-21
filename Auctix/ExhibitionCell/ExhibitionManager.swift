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

class ExhibitionManager: ExhibitionManagerProtokol{
    
    static let shared: ExhibitionManagerProtokol = ExhibitionManager()
    
    private init(){}
    
    func loadExhibition() -> [Exhibition] {
        return [
            Exhibition(titleImg: .init(named: "Image1") ?? .init(), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd"),
            Exhibition(titleImg: #imageLiteral(resourceName: "Image1"), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd"),
            Exhibition(titleImg: .init(named: "Image2") ?? .init(), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd")
        ]
    }
    
    
}
