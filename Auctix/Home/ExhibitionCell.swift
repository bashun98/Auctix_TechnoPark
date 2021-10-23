//
//  ExhibitionCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    
    static let reuseID: String = "ExhibitionCell"
    static let nib = UINib(nibName: String(describing: ExhibitionCell.self), bundle: nil)
    
    private let title1 = UILabel()
    private let text_opis1 = UILabel()
    
    private let titleViewImg1 = UIImageView()
    private let botton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
    }
    
    func setupElements() {
        titleViewImg1.translatesAutoresizingMaskIntoConstraints = false
        title1.translatesAutoresizingMaskIntoConstraints = false
        text_opis1.translatesAutoresizingMaskIntoConstraints = false
        titleViewImg1.backgroundColor = .red
        title1.font = UIFont.systemFont(ofSize: 18)
    }
    

    
    func configure(with data: Exhibitions){
        titleViewImg1.image = UIImage(named: data.titleImg)
        title1.text = data.title
        text_opis1.text = data.text_opis
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayuot()
    }

    func setupLayuot(){

//        NSLayoutConstraint.activate([
//            titleViewImg1.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 90),
//            titleViewImg1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
//            titleViewImg1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
//            titleViewImg1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
//            //titleViewImg1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
//            title1.bottomAnchor.constraint(equalTo: titleViewImg1.bottomAnchor, constant: 5),
//            title1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
//            title1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
//            text_opis1.bottomAnchor.constraint(equalTo: title1.bottomAnchor, constant: 5),
//            text_opis1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
//            text_opis1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
//            botton.bottomAnchor.constraint(equalTo: text_opis1.bottomAnchor, constant: 5),
//
//        ])
    }

}

extension ExhibitionCell {
    func setupConstraints() {
        addSubview(titleViewImg1)
        addSubview(title1)
        addSubview(text_opis1)
        
        //image
        titleViewImg1.heightAnchor.constraint(equalToConstant: 90).isActive = true
        titleViewImg1.widthAnchor.constraint(equalToConstant: 90).isActive = true
        titleViewImg1.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleViewImg1.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleViewImg1.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        //title
        title1.topAnchor.constraint(equalTo: titleViewImg1.bottomAnchor, constant: 10).isActive = true
        title1.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        title1.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        //opis
        text_opis1.topAnchor.constraint(equalTo: title1.bottomAnchor, constant: 10).isActive = true
        text_opis1.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        text_opis1.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
