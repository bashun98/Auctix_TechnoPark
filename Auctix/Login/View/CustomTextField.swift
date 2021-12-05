//
//  CustomTextField.swift
//  Auctix
//
//  Created by mac on 04.11.2021.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String){
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        layer.cornerRadius = 10
        
        borderStyle = .none
        textColor = UIColor.prussianBlue.withAlphaComponent(0.6)
        keyboardAppearance = .dark
        backgroundColor = UIColor.searchColor.withAlphaComponent(0.5)
        setHeight(height: 50)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.prussianBlue.withAlphaComponent(0.6)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
