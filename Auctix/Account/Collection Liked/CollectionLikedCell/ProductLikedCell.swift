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
    private let actively = UILabel()
    private let price = UILabel()
    private var netImage = ProductImageLoader.shared
    private let prodName = UILabel()
    
    var isFavorit: Bool?
    var isActiv: Bool?
    
    weak var delegate: ProductCellDescription?
    
    lazy var likeButton: UIButton = {
         let button = UIButton(type: .system)
            button.setImage(UIImage(named: "like_red"), for: .normal)
            button.tintColor = .white
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

    public func getImage() -> UIImage? {
        return imageProd.image
    }
    
    func setupElements() {
        nameProd.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameProd.textColor = .white
        
        actively.textColor = .white
        actively.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        price.textColor = UIColor.honeyYellow
        price.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        imageProd.contentMode = .scaleAspectFill
        imageProd.clipsToBounds = true
        imageProd.layer.cornerRadius = 5
        imageProd.isUserInteractionEnabled = true
        imageProd.translatesAutoresizingMaskIntoConstraints = false
        nameProd.translatesAutoresizingMaskIntoConstraints = false
        actively.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        
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
        nameProd.text = data.name
        //price.text = String(data.currentPrice) + "$"
        if isActiv ?? false {
            actively.text = "Bid: active"
            price.attributedText = .none
            price.text = (String(data.currentPrice) + "$")
        } else {
            actively.text = "Bid: time is over"
            price.attributedText = (String(data.currentPrice) + "$").strikeThrough()
        }
        if isFavorit ?? false {
            likeButton.tintColor = .red
        } else {
            likeButton.tintColor = .white
        }
    }
    
    
    
    public func setupCurrentPrice(currentPrice: String){
        price.text = currentPrice + "$"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    
    private func setupViews() {
        contentView.addSubview(imageProd)
        imageProd.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
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
    
    @objc
    func didTabButton() {
        delegate?.didTabButton(nameProduct: nameProd.text ?? "", isFavorit: isFavorit ?? false)
    }
}

extension ProductLikedCell {
    
    func setupLayuot() {
        NSLayoutConstraint.activate([
            
            imageProd.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageProd.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageProd.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageProd.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            likeButton.topAnchor.constraint(equalTo: imageProd.topAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: imageProd.leadingAnchor, constant: 10),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            likeButton.widthAnchor.constraint(equalToConstant: 28),

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
