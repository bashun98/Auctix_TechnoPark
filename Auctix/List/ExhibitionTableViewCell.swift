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
    
    private let exhibitionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
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
    
    private let exhibitionExpirationDate: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private struct Constraints {
        static let labelPosition: CGFloat = 20
        static let imageFromLeftRight: CGFloat = 12
        static let imageFromTopBottom: CGFloat = 5
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        setupViews()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    func configure(with exhibition: Exhibition) {
        //exhibitionImage.image = exhibition.titleImg
        exhibitionName.text = exhibition.name
        exhibitionCity.text = exhibition.city + ","
        exhibitionCountry.text = exhibition.country
        exhibitionExpirationDate.text = "Exhibition closing date: " + exhibition.expirationDate
    }
    
    private func setupViews() {
        addSubview(exhibitionImage)
        exhibitionImage.addSubview(container)
        container.layer.addSublayer(gradient)
        exhibitionImage.addSubview(exhibitionName)
        exhibitionImage.addSubview(exhibitionCity)
        exhibitionImage.addSubview(exhibitionCountry)
        exhibitionImage.addSubview(exhibitionExpirationDate)
    }
    
    private func setupGradient() {
        gradient.colors = [UIColor.darkGrad.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.cornerRadius = layer.cornerRadius
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1, b: 0, c: 0, d: -5.8, tx: 1, ty: 3.4))
        gradient.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        gradient.position = center
    }
    
    private func setupLayout() {
        exhibitionImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constraints.imageFromLeftRight)
            make.top.bottom.equalToSuperview().inset(Constraints.imageFromTopBottom)
        }
        exhibitionName.snp.makeConstraints { make in
            make.top.equalTo(exhibitionImage).inset(Constraints.labelPosition)
            make.trailing.equalTo(exhibitionImage).inset(Constraints.labelPosition / 2)
        }
        exhibitionCity.snp.makeConstraints { make in
            make.top.equalTo(exhibitionName).inset(Constraints.labelPosition * 2)
            make.trailing.equalTo(exhibitionName)
        }
        exhibitionCountry.snp.makeConstraints { make in
            make.top.equalTo(exhibitionCity).inset(Constraints.labelPosition)
            make.trailing.equalTo(exhibitionCity)
        }
        exhibitionExpirationDate.snp.makeConstraints { make in
            make.top.equalTo(exhibitionCountry).inset(Constraints.labelPosition)
            make.trailing.equalTo(exhibitionCountry)
        }
    }
}
