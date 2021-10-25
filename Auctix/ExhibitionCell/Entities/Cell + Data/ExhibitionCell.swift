//
//  ExhibitionCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

protocol ButtonClic: AnyObject {
    func didTabButton()
}

class ExhibitionCell: UICollectionViewCell {
    
    // TODO: Нейминг поменяй (поменял)
    private let imageExhib = UIImageView()
    
    //private let jumpButton = UIButton (type: .system)
     private lazy var jumpButton: UIButton = {
         let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
            button.setImage(UIImage(named: "reset"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
    weak var delegate: ButtonClic?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.contentView.isUserInteractionEnabled = true
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
        jumpButton.isUserInteractionEnabled = true
        //jumpButton.isEnabled = true
        imageExhib.isUserInteractionEnabled = true
        
        imageExhib.clipsToBounds = true
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
        contentView.addSubview(imageExhib)
        imageExhib.addSubview(jumpButton)
        jumpButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
        
    }
    @objc func didTabButton() {
        delegate?.didTabButton()
    }
}

extension ExhibitionCell {
    
    func setupLayuot() {
        // TODO: Переделай на setupLayout и делай по одному образцу, чтобы все едино было  (сделал)
        // TODO: зачем self ? Тут итак нет разногласий (сделал)
        NSLayoutConstraint.activate([
            imageExhib.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageExhib.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageExhib.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageExhib.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
            jumpButton.heightAnchor.constraint(equalToConstant: 56),
            //jumpButton.topAnchor.constraint(equalTo: contentView.bottomAnchor)
            jumpButton.bottomAnchor.constraint(equalTo: imageExhib.bottomAnchor, constant: -20),
            jumpButton.leadingAnchor.constraint(equalTo: imageExhib.leadingAnchor, constant: 40),
            jumpButton.trailingAnchor.constraint(equalTo: imageExhib.trailingAnchor, constant: -40)
        ])
    }
}

extension ExhibitionCell {
    
    static var nib  : UINib{
        return UINib(nibName: identifire, bundle: nil)
    }
    
    static var identifire : String{
        return String(describing: self)
    }
}
