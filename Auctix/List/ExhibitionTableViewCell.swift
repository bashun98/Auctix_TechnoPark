//
//  ExhibitionTableViewCell.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit
import SnapKit

class ExhibitionTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    private let container = UIView()
    private let gradient = CAGradientLayer()
    
    private let myImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let exhibitionName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let exhibitionCity: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let exhibitionCountry: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private struct Constraints {
        static let labelPosition: CGFloat = 20
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        setupViews()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    func configure(with exhibition: Exhibition) {
        myImage.image = exhibition.titleImg
        exhibitionName.text = exhibition.title
        exhibitionCity.text = exhibition.city + ","
        exhibitionCountry.text = exhibition.country
    }
    
    private func setupViews() {
        addSubview(myImage)
        myImage.addSubview(container)
        container.layer.addSublayer(gradient)
        myImage.addSubview(exhibitionName)
        myImage.addSubview(exhibitionCity)
        myImage.addSubview(exhibitionCountry)
    }
    
    private func setupGradient() {
        gradient.colors = [UIColor.darkGrad.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.cornerRadius = layer.cornerRadius
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1, b: 0, c: 0, d: -5.8, tx: 1, ty: 3.4))
        gradient.bounds = bounds.insetBy(dx: -0.5*bounds.size.width, dy: -0.5*bounds.size.height)
        gradient.position = center
    }
    
    private func setupLayout() {
        myImage.frame = contentView.bounds.inset(by: UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12))
        exhibitionName.snp.makeConstraints { make in
            make.top.equalTo(myImage).inset(Constraints.labelPosition)
            make.trailing.equalTo(myImage).inset(Constraints.labelPosition / 2)
        }
        exhibitionCity.snp.makeConstraints { make in
            make.top.equalTo(exhibitionName).inset(Constraints.labelPosition * 2)
            make.trailing.equalTo(exhibitionName)
        }
        exhibitionCountry.snp.makeConstraints { make in
            make.top.equalTo(exhibitionCity).inset(Constraints.labelPosition)
            make.trailing.equalTo(exhibitionCity)
        }
    }
}
