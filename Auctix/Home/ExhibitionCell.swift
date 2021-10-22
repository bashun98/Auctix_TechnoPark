//
//  ExhibitionCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    
    static let reuseID = String(describing: ExhibitionCell.self)
    static let nib = UINib(nibName: String(describing: ExhibitionCell.self), bundle: nil)
    
    private let title1 = UILabel()
    private let text_opis1 = UILabel()
    
    private let titleViewImg1 = UIImageView()
    private let botton = UIButton()

//    required init?(coder: NSCoder) {
//        super .init(coder: coder)
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        firstSetup()
        
    }
    
    func firstSetup() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 4
        title1.font = UIFont.systemFont(ofSize: 18)
        titleViewImg1.translatesAutoresizingMaskIntoConstraints = false
        title1.translatesAutoresizingMaskIntoConstraints = false
        text_opis1.translatesAutoresizingMaskIntoConstraints = false
    
    }
    
    func configure(with data: Exhibition){
        titleViewImg1.image = data.titleImg
        title1.text = data.title
        text_opis1.text = data.text_opis
        backgroundColor = .red
    }
    
    //override
//    func update(title: String, image: UIImage, opis: String) {
//        titleViewImg1.image = image
//        title1.text = title
//        text_opis1.text = opis
//    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayuot()
    }

    func setupLayuot(){

        NSLayoutConstraint.activate([
            titleViewImg1.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 90),
            titleViewImg1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleViewImg1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleViewImg1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            //titleViewImg1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            title1.bottomAnchor.constraint(equalTo: titleViewImg1.bottomAnchor, constant: 5),
            title1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            title1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            text_opis1.bottomAnchor.constraint(equalTo: title1.bottomAnchor, constant: 5),
            text_opis1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            text_opis1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            botton.bottomAnchor.constraint(equalTo: text_opis1.bottomAnchor, constant: 5),

        ])
    }

}
