//
//  sec.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 23.10.2021.
//

import Foundation
struct MySections: Decodable, Hashable {
    
    let type: String
    let title: String
    let items: [Exhibitions]
    
}
