//
//  ViewNoProducts.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 13.11.2021.
//

import Firebase
import UIKit

class ViewNoProducts: UIView{
        
    private let requestLabel = UILabel()

    weak var delegate: GoToLogin?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview(requestLabel)
        setupElements()

    }
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
}

extension ViewNoProducts {
    func setupElements(){

        requestLabel.text = "There will be products on which you will bid."
        requestLabel.font = .systemFont(ofSize: 36)
        requestLabel.textColor = UIColor.blueGreen
        requestLabel.numberOfLines = 0
        requestLabel.translatesAutoresizingMaskIntoConstraints = false
        requestLabel.textAlignment = .center
 
        self.backgroundColor = UIColor.white
    }
}

extension ViewNoProducts {
    func setupLayuot(){
        NSLayoutConstraint.activate([
            requestLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height/4),
            requestLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            requestLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
