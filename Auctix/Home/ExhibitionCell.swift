//
//  ExhibitionCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    // TODO: вынести в расширение, погугли
    static let reuseID: String = "ExhibitionCell"
    static let nib = UINib(nibName: String(describing: ExhibitionCell.self), bundle: nil)
    
    // TODO: Нейминг поменяй
    private let titleViewImg1 = UIImageView()
    private let botton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupElements()
    }
     
    required init?(coder: NSCoder) {
        // TODO: никаких фаталов
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupElements() {
        botton.setTitle("default", for: .normal)
        botton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        botton.setTitleColor(.white, for: .normal)
        botton.layer.cornerRadius = 28
        botton.backgroundColor = .systemBlue
        
        titleViewImg1.layer.cornerRadius = 20
        titleViewImg1.clipsToBounds = true
        titleViewImg1.backgroundColor = .red.withAlphaComponent(0.3)
   
        botton.translatesAutoresizingMaskIntoConstraints = false
        titleViewImg1.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(with data: Exhibition){
        titleViewImg1.image = data.titleImg
        botton.setTitle(data.title, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(titleViewImg1)
        titleViewImg1.addSubview(botton)
    }
}

extension ExhibitionCell {
    
    func setupConstraints() {
        // TODO: Переделай на setupLayout и делай по одному образцу, чтобы все едино было
        // TODO: зачем self ? Тут итак нет разногласий
        NSLayoutConstraint.activate([
        titleViewImg1.topAnchor.constraint(equalTo: self.topAnchor),
        titleViewImg1.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        titleViewImg1.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        titleViewImg1.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        
        botton.heightAnchor.constraint(equalToConstant: 56),
        botton.bottomAnchor.constraint(equalTo: titleViewImg1.bottomAnchor, constant: -20),
        botton.leadingAnchor.constraint(equalTo: titleViewImg1.leadingAnchor, constant: 40),
        botton.trailingAnchor.constraint(equalTo: titleViewImg1.trailingAnchor, constant: -40)
        ])
    }
}
