//
//  ExhibitionCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

protocol ReuseIdentifying {
    static var reuseID: String { get }
}
class ExhibitionCell: UICollectionViewCell, ReuseIdentifying {
    
    // TODO: вынести в расширение, погугли (нашел)
    //static let reuseID: String = "ExhibitionCell"
    static let nib = UINib(nibName: String(describing: ExhibitionCell.self), bundle: nil)
    
    // TODO: Нейминг поменяй (поменял)
    private let imageExhib = UIImageView()
    private let jumpButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupElements()
    }
     
    required init?(coder: NSCoder) {
        // TODO: никаких фаталов  (исправил)
        super .init(coder: coder)
    }
    
    func setupElements() {
        jumpButton.setTitle("default", for: .normal)
        jumpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        jumpButton.setTitleColor(.white, for: .normal)
        jumpButton.layer.cornerRadius = 28
        jumpButton.backgroundColor = UIColor.blueGreen
        jumpButton.clipsToBounds = true
        
        imageExhib.layer.cornerRadius = 20
        jumpButton.translatesAutoresizingMaskIntoConstraints = false
        imageExhib.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(with data: Exhibition){
        imageExhib.image = data.titleImg
        jumpButton.setTitle(data.title, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    
    private func setupViews() {
        addSubview(imageExhib)
        imageExhib.addSubview(jumpButton)
    }
}

extension ExhibitionCell {
    
    func setupLayuot() {
        // TODO: Переделай на setupLayout и делай по одному образцу, чтобы все едино было  (сделал)
        // TODO: зачем self ? Тут итак нет разногласий (сделал)
        NSLayoutConstraint.activate([
            imageExhib.topAnchor.constraint(equalTo: topAnchor),
            imageExhib.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageExhib.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageExhib.trailingAnchor.constraint(equalTo: trailingAnchor),
        
            jumpButton.heightAnchor.constraint(equalToConstant: 56),
            jumpButton.bottomAnchor.constraint(equalTo: imageExhib.bottomAnchor, constant: -20),
            jumpButton.leadingAnchor.constraint(equalTo: imageExhib.leadingAnchor, constant: 40),
            jumpButton.trailingAnchor.constraint(equalTo: imageExhib.trailingAnchor, constant: -40)
        ])
    }
}
extension ExhibitionCell {
    
}
extension ReuseIdentifying {
    static var reuseID: String {
        return String(describing: Self.self)
    }
}
