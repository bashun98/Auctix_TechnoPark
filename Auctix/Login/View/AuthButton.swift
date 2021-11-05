//
//  AuthButton.swift
//  Auctix
//
//  Created by mac on 04.11.2021.
//

import UIKit

class AuthButton: UIButton {
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 25
        backgroundColor = UIColor.honeyYellow
        setTitleColor(UIColor(white: 1, alpha: 1.0), for: .normal)
        setHeight(height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
