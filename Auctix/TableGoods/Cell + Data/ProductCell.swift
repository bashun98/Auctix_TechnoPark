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
    //private let jumpButton = UIButton()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        //setupGradient()
        setupElements()
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
        
        imageProd.clipsToBounds = true
        imageProd.layer.cornerRadius = 5
        
        imageProd.translatesAutoresizingMaskIntoConstraints = false
        nameProd.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        cost.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupGradient(){
       
        
        
//        gradient.frame = imageProd.bounds
//        //gradient.contents = imageProd.image?.cgImage
//        gradient.colors = [UIColor.green.cgColor, UIColor.blue.cgColor]
//        gradient.startPoint = CGPoint(x: 0, y: 0)
//        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        
       
        gradient.frame = containerView.frame
        gradient.colors = [UIColor.lightGrad, UIColor.darkGrad]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        //containerView.layer.insertSublayer(gradient, at: 0)
        
        //imageProd.insertSubview(containerView, at: 0)
        

//        imageProd.bringSubviewToFront(view)
//        gradient.frame = self.bounds
//        gradient.colors = [UIColor.lightGrad, UIColor.darkGrad]
//        gradient.locations = [0,1]
//        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
//        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        //gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1, b: 0, c: 0, d: -5.8, tx: 1, ty: 3.4))
        
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
        addSubview(containerView)
        containerView.addSubview(imageProd)
        setupGradient()
        //contentView.layer.addSublayer(gradient)
        //layer.addSublayer(gradient)
//        imageProd.addSubview(nameProd)
//        imageProd.addSubview(time)
//        imageProd.addSubview(cost)
        
    }
}

extension ProductCell {
    
    func setupLayuot() {
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            imageProd.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageProd.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageProd.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageProd.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        
            //nameProd.heightAnchor.constraint(equalToConstant: 56),
//            nameProd.topAnchor.constraint(equalTo: imageProd.topAnchor, constant: 10),
//            nameProd.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
//            //nameProd.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
//
//            cost.topAnchor.constraint(equalTo: nameProd.bottomAnchor, constant: 5),
//            cost.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
//            //cost.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
//
//            time.topAnchor.constraint(equalTo: cost.bottomAnchor, constant: 5),
//            time.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
//            //time.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
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
