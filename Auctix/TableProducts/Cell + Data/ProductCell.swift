//
//  GoodsCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit
import Firebase

protocol ProductCellDescription: AnyObject {
    func didTabButton(nameProduct: String, isFavorit: Bool)
}

class ProductCell: UITableViewCell {
    
    static let nib = UINib(nibName: String(describing: ExhibitionCell.self), bundle: nil)

    private let containerView = UIView()
    private let gradient = CAGradientLayer()
    private let imageProd = UIImageView()
    private let likeImage = UIImageView()
    private let nameProd = UILabel()
    private let time = UILabel()
    private let cost = UILabel()
    var isFavorit: Bool?

    lazy var likeButton: UIButton = {
         let button = UIButton(type: .system)
            button.setImage(UIImage(named: "like_blue"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    unowned var delegate: ProductCellDescription?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupGradient()
        setupElements()
        setupViews()
    }
     
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    func setupElements() {
        nameProd.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameProd.textColor = .white
        
        time.textColor = .white
        time.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        cost.textColor = UIColor.honeyYellow
        cost.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        imageProd.contentMode = .scaleAspectFill
        imageProd.clipsToBounds = true
        imageProd.layer.cornerRadius = 5
        imageProd.isUserInteractionEnabled = true
        imageProd.translatesAutoresizingMaskIntoConstraints = false
        nameProd.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        cost.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //containerView.isUserInteractionEnabled = false
    }
    // настройка градиента(тени) на ячейку
    func setupGradient(){
        gradient.colors = [UIColor.darkGrad.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.cornerRadius = layer.cornerRadius
        
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1, b: 0, c: 0, d: -5.8, tx: 1, ty: 3.4))
        gradient.bounds = bounds.insetBy(dx: -0.5*bounds.size.width, dy: -0.5*bounds.size.height)
        gradient.position = center
        
    }
    
    public func getImageView() -> UIImageView {
        return imageProd
    }
    
    func configure(with data: Product){
        nameProd.text = data.name
        cost.text = String(data.currentPrice) + "$"
        time.text = "1 work 3 tausent"
        if isFavorit ?? false {
            likeButton.setImage(UIImage(named: "like_red"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like_blue"), for: .normal)
        }
        //isFavorit = false
    }
    
    public func getImage() -> UIImage? {
        return imageProd.image
    }
    
    public func setupCurrentPrice(currentPrice: String){
        cost.text = currentPrice + "$"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    
    private func setupViews() {
        contentView.addSubview(imageProd)
        imageProd.addSubview(containerView)
        containerView.layer.addSublayer(gradient)

        imageProd.addSubview(nameProd)
        imageProd.addSubview(time)
        imageProd.addSubview(cost)
        imageProd.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
    }
    
    @objc
    func didTabButton() {
        delegate?.didTabButton(nameProduct: nameProd.text ?? "", isFavorit: isFavorit ?? false)
    }
}

extension ProductCell {
    
    func setupLayuot() {
        NSLayoutConstraint.activate([
            
            imageProd.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageProd.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            imageProd.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageProd.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            containerView.topAnchor.constraint(equalTo: imageProd.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: imageProd.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: imageProd.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: imageProd.trailingAnchor),
      
            nameProd.topAnchor.constraint(equalTo: imageProd.topAnchor, constant: 10),
            nameProd.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            cost.topAnchor.constraint(equalTo: nameProd.bottomAnchor, constant: 5),
            cost.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            time.topAnchor.constraint(equalTo: cost.bottomAnchor, constant: 5),
            time.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            likeButton.bottomAnchor.constraint(equalTo: imageProd.bottomAnchor, constant: -10),
            likeButton.leadingAnchor.constraint(equalTo: imageProd.leadingAnchor, constant: 10),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 35),
       ])
  }
}

    
extension ProductCell {
    
    static var nibProd : UINib{
        return UINib(nibName: identifireProd, bundle: nil)
    }
    
    static var identifireProd : String{
        return String(describing: self)
    }
}
