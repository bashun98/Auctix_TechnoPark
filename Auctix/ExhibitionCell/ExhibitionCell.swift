//
//  ExhibitionCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    let title1 = UILabel()
    let text_opis1 = UILabel()
    let titleImg1 = UIImage()
    let titleViewImg1 = UIImageView()
    let botton = UIButton()
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
    
    func configure(with exhibition: Exhibition){
        titleViewImg1.image = titleImg1
        title1.text = exhibition.title
        text_opis1.text = exhibition.text_opis
    }
    
    //override
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    
    func setupLayuot(){
        NSLayoutConstraint.activate([
            titleViewImg1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleViewImg1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleViewImg1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleViewImg1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            
        ])
    }
}
