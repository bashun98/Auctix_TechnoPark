//
//  GoodsCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit

protocol ReuseIdentifyingProd {
    static var reuseID: String { get }
}
class ProductCell: UICollectionViewCell, ReuseIdentifyingProd {
    
    static let nib = UINib(nibName: String(describing: ExhibitionCell.self), bundle: nil)

    private let gradient = CAGradientLayer()
    private let imageProd = UIImageView()
    private let nameProd = UILabel()
    private let time = UILabel()
    private let cost = UILabel()
    //private let jumpButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupViews()
        setupElements()
    }
     
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    func setupElements() {
        nameProd.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        nameProd.textColor = .white
        
        time.textColor = .white
        time.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        cost.textColor = UIColor.honeyYellow
        cost.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        imageProd.clipsToBounds = true
        imageProd.layer.cornerRadius = 20
        
        imageProd.translatesAutoresizingMaskIntoConstraints = false
        nameProd.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        cost.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupGradient(){
        gradient.colors = [UIColor.lightGrad, UIColor.darkGrad]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
    }
    
    func configure(with data: Product){
        imageProd.image = data.productImg
        nameProd.text = data.title
        cost.text = data.cost
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    
    private func setupViews() {
        addSubview(imageProd)
        imageProd.layer.insertSublayer(gradient, at: 0)
        imageProd.addSubview(nameProd)
        imageProd.addSubview(time)
        imageProd.addSubview(cost)
        
    }
}

extension ProductCell {
    
    func setupLayuot() {
        NSLayoutConstraint.activate([
            imageProd.topAnchor.constraint(equalTo: topAnchor),
            imageProd.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageProd.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageProd.trailingAnchor.constraint(equalTo: trailingAnchor),
        
            //nameProd.heightAnchor.constraint(equalToConstant: 56),
            nameProd.topAnchor.constraint(equalTo: imageProd.topAnchor, constant: 10),
            nameProd.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 11),
            nameProd.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -11),
            
            cost.topAnchor.constraint(equalTo: nameProd.bottomAnchor, constant: 5),
            cost.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 11),
            cost.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -11),
            
            time.topAnchor.constraint(equalTo: cost.bottomAnchor, constant: 5),
            time.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 11),
            time.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -11),
        ])
    }
}
extension ExhibitionCell {
    
}
extension ReuseIdentifyingProd {
    static var reuseID: String {
        return String(describing: Self.self)
    }
}
