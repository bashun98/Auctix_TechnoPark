//
//  Goods.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit

struct Product{
    let id: String = UUID().uuidString
    let productImg: UIImage
    let title: String
    let text_opis: String
    let exhibition: String
    let status: String
    let cost: String
}
