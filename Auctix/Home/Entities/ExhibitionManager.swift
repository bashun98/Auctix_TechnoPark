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

class ExhibitionManager {
    
//    static let shared: ExhibitionManagerProtokol = ExhibitionManager()
//
//    private init(){}
//
//    func loadExhibition() -> [Exhibition] {
//        return [
//            Exhibition(titleImg: .init(named: "Image1") ?? .init(), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd"),
//            Exhibition(titleImg: #imageLiteral(resourceName: "Image1"), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd"),
//            Exhibition(titleImg: .init(named: "Image2") ?? .init(), title: "House Kult", text_opis: "dsfghj sdhfjikf hjkh sdfhjk f hjksdf  sdhhsd hsdfhfhjks  dhhd")
//        ]
//    }
    static func get() -> [Exhibition] {
            return [
                Exhibition(titleImg: #imageLiteral(resourceName: "AccTabBar"), title: "Proba", text_opis: "Proba"),
                
                Exhibition(titleImg: #imageLiteral(resourceName: "ListTabBar"), title: "Proba1", text_opis: "Proba1"),
                
                Exhibition(titleImg: #imageLiteral(resourceName: "Image3"), title: "Proba2", text_opis: "Proba2"),
                Exhibition(titleImg: #imageLiteral(resourceName: "Search"), title: "Proba3", text_opis: "Proba3"),
            
                Exhibition(titleImg: #imageLiteral(resourceName: "HomeTabBar"), title: "Proba4", text_opis: "Proba4"),
            ]
        }
    
}
