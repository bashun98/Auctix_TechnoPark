//
//  ExhibitionTableViewCell.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit
import SnapKit

final class ExhibitionTableViewCell: UITableViewCell {
    
    private struct Constants {
        static let labelPosition: CGFloat = 20
        static let imageFromLeftRight: CGFloat = 12
        static let imageFromTopBottom: CGFloat = 5
    }
    
    static let identifier = "CustomTableViewCell"
    private let container = UIView()
    private let gradient = CAGradientLayer()

    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        setupViews()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    func getImageView() -> UIImageView {
        return mainImageView
    }
    
    func configure(with exhibition: Exhibition) {
        nameLabel.text = exhibition.name
        cityLabel.text = exhibition.city
        countryLabel.text = exhibition.country
        
        let days = calculateTimeDifference(from: exhibition.expirationDate)
        if Int(days) == 1 {
            dateLabel.text = "Trading ends today!"
        } else {
            dateLabel.text = "\(days) days left until closing"
        }
    }
    
    func calculateTimeDifference(from dateTime1: String) -> String {
        let dateWithTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let date = dateFormatter.string(from: dateWithTime) // 02.10.17

        let dateAsString = dateTime1
        let date1 = dateFormatter.date(from: dateAsString)!
                                
        let date2 = dateFormatter.date(from: date)!
        
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .year]
        let difference = (Calendar.current as NSCalendar).components(components, from: date2, to: date1, options: [])
        
        let dateTimeDifferenceString = "\(difference.day!)"
        return dateTimeDifferenceString
        
    }
    
    private func setupViews() {
        addSubview(mainImageView)
        mainImageView.addSubview(container)
        container.layer.addSublayer(gradient)
        mainImageView.addSubview(nameLabel)
        mainImageView.addSubview(cityLabel)
        mainImageView.addSubview(countryLabel)
        mainImageView.addSubview(dateLabel)
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
        mainImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.imageFromLeftRight)
            make.top.bottom.equalToSuperview().inset(Constants.imageFromTopBottom)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView).inset(Constants.labelPosition)
            make.trailing.equalTo(mainImageView).inset(Constants.labelPosition / 2)
        }
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel).inset(Constants.labelPosition * 2)
            make.trailing.equalTo(nameLabel)
        }
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel).inset(Constants.labelPosition)
            make.trailing.equalTo(cityLabel)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel).inset(Constants.labelPosition)
            make.trailing.equalTo(countryLabel)
        }
    }
}
