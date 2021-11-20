//
//  CollectionLikedCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 15.11.2021.
//
import UIKit


class ProductLikedCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let gradient = CAGradientLayer()
    private let imageProd = UIImageView()
    private let nameProd = UILabel()
    private let time = UILabel()
    private let cost = UILabel()
    private var netImage = ProductImageLoader.shared
    private let prodName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupElements()
    }
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }

    public func getImage() -> UIImage? {
        return imageProd.image
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
        imageProd.image = #imageLiteral(resourceName: "VK")
        nameProd.text = data.name
        cost.text = String(data.currentPrice) + "$"
        time.text = "1 work 3 tausent"
        prodName.text = data.name + ".jpeg"
        //netImage.image(with: prodName.text!) { [weak self] image in
//            self?.imageProd.image = image
//        }
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
//        imageProd.addSubview(containerView)
//        containerView.layer.addSublayer(gradient)
//
//        imageProd.addSubview(nameProd)
//        imageProd.addSubview(time)
//        imageProd.addSubview(cost)
    }

    public func getImageView() -> UIImageView {
            return imageProd
        }
}

extension ProductLikedCell {
    
    func setupLayuot() {
        NSLayoutConstraint.activate([
            
            imageProd.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageProd.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageProd.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageProd.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
//            containerView.topAnchor.constraint(equalTo: imageProd.topAnchor),
//            containerView.bottomAnchor.constraint(equalTo: imageProd.bottomAnchor),
//            containerView.leadingAnchor.constraint(equalTo: imageProd.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: imageProd.trailingAnchor),
//
//            nameProd.topAnchor.constraint(equalTo: imageProd.topAnchor, constant: 10),
//            nameProd.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
//
//            cost.topAnchor.constraint(equalTo: nameProd.bottomAnchor, constant: 5),
//            cost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
//
//            time.topAnchor.constraint(equalTo: cost.bottomAnchor, constant: 5),
//            time.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
       ])
  }
}

    
extension ProductLikedCell {
    
    static var nibProdLiked : UINib{
        return UINib(nibName: identifireProdLiked, bundle: nil)
    }
    
    static var identifireProdLiked : String{
        return String(describing: self)
    }
}
