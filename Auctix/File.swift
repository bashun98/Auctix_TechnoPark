//
//  File.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import  UIKit

public enum FontsName: String {
    case black      = "Nunito-Black"
    case regular   = "Nunito-Regular"
    case light     = "Nunito-Light"
}

extension UIFont {
    static func get(with weight: FontsName, size: CGFloat) -> UIFont {
        return .init(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
