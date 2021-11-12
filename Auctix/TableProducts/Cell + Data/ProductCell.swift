//
//  GoodsCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 24.10.2021.
//

import UIKit


class ProductCell: UITableViewCell {
    
    static let nib = UINib(nibName: String(describing: ExhibitionCell.self), bundle: nil)

    private let containerView = UIView()
    private let gradient = CAGradientLayer()
    private let imageProd = UIImageView()
    private let nameProd = UILabel()
    private let time = UILabel()
    private let cost = UILabel()
    private var netImage = ProductImageLoader.shared
    private let prodName = UILabel()
    
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
    
    func configure(with data: Product){
        //imageProd.image = data.productImg
        nameProd.text = data.name
        cost.text = String(data.currentPrice) + "$"
        time.text = "1 work 3 tausent"
        prodName.text = data.name + ".jpeg"
        netImage.image(with: prodName.text!) { [weak self] image in
            self?.imageProd.image = image
        }
    }
    
    
    
    public func setupCurrentPrice(currentPrice: String){
        cost.text = currentPrice + "$"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    
    private func setupViews() {
        addSubview(imageProd)
        imageProd.addSubview(containerView)
        containerView.layer.addSublayer(gradient)

        imageProd.addSubview(nameProd)
        imageProd.addSubview(time)
        imageProd.addSubview(cost)
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
