//
//  ExhibitionCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    // TODO: Нейминг поменяй (поменял)
    private let imageExhib = UIImageView()
    private var netImage = ExhibitionsImageLoader.shared
    private let exhName = UILabel()
    lazy var jumpButton: UIButton = {
         let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
            button.setImage(UIImage(named: "reset"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupElements()
    }
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    func setupElements() {
        
        jumpButton.setTitle("default", for: .normal)
        jumpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        jumpButton.titleLabel?.isUserInteractionEnabled = false
        jumpButton.setTitleColor(.white, for: .normal)
        jumpButton.layer.cornerRadius = 28
        jumpButton.backgroundColor = UIColor.blueGreen
        jumpButton.clipsToBounds = true
        jumpButton.isUserInteractionEnabled = true
        //jumpButton.isEnabled = true
        imageExhib.isUserInteractionEnabled = true
        
        imageExhib.clipsToBounds = true
        imageExhib.contentMode = .scaleAspectFill
        imageExhib.layer.cornerRadius = 20
        imageExhib.translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 5, height: 10)
        layer.cornerRadius = 20
        layer.shadowOpacity = 0.3
    }
    
    func configure(with data: Exhibition){
       // imageExhib.image = data.titleImg
        jumpButton.setTitle(data.name, for: .normal)
        exhName.text = data.name + ".jpeg"
        netImage.image(with: exhName.text!) { [weak self] image in
            self?.imageExhib.image = image
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    
    private func setupViews() {
        contentView.addSubview(imageExhib)
        imageExhib.addSubview(jumpButton)
    }
}

extension ExhibitionCell {
    
    func setupLayuot() {
        NSLayoutConstraint.activate([
            imageExhib.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            imageExhib.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
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
