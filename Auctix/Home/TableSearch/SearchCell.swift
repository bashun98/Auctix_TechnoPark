//
//  SearchCell.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 09.12.2021.
//

import UIKit
import Firebase

class SearchCell: UITableViewCell {
    
    static let nib = UINib(nibName: String(describing: ExhibitionCell.self), bundle: nil)

    private let nameProd = UILabel()
    private let imageProd = UIImageView()
    //private let imageProd = UIImageView()
    unowned var delegate: ProductCellDescription?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements()
        setupViews()
    }
     
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    func setupElements() {
        
        nameProd.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameProd.textColor = UIColor.lightCornflowerBlue
        nameProd.translatesAutoresizingMaskIntoConstraints = false

    }
    
    public func getImageView() -> UIImageView {
        return imageProd
    }
    
    public func getImage() -> UIImage? {
        return imageProd.image
    }
  
    func configure(with data: Product){
        nameProd.text = data.name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    
    private func setupViews() {

        contentView.addSubview(nameProd)

    }
    
    @objc
    func didTabButton() {
//        delegate?.didTabButton(nameProduct: nameProd.text ?? "", isFavorit: isFavorit ?? false)
    }
}

extension SearchCell {

    func setupLayuot() {
        NSLayoutConstraint.activate([
            nameProd.topAnchor.constraint(equalTo: topAnchor),
            nameProd.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameProd.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
       ])
  }
}

    
extension SearchCell {
    
    static var nibSearch : UINib{
        return UINib(nibName: identifireSearch, bundle: nil)
    }
    
    static var identifireSearch : String{
        return String(describing: self)
    }
}
