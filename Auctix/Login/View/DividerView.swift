//
//  DividerView.swift
//  Auctix
//
//  Created by mac on 04.11.2021.
//

import UIKit

class DividerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.text = "OR"
        label.textColor = UIColor.prussianBlue.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(label)
        label.centerX(inView: self)
        label.centerY(inView: self)
        
        let devider1 = UIView()
        devider1.backgroundColor = UIColor.prussianBlue.withAlphaComponent(0.2)
        addSubview(devider1)
        devider1.centerY(inView: self)
        devider1.anchor(left: leftAnchor, right: label.leftAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
        
        let devider2 = UIView()
        devider2.backgroundColor = UIColor.prussianBlue.withAlphaComponent(0.2)
        addSubview(devider2)
        devider2.centerY(inView: self)
        devider2.anchor(left: label.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
