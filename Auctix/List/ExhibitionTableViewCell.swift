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
    private var netImage = ExhibitionsImageLoader.shared
    private let exhName = UILabel()
    private let exhibitionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let exhibitionName: UILabel = {
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
        exhibitionImage.image = #imageLiteral(resourceName: "VK")
        exhibitionName.text = exhibition.name
        exhibitionCity.text = exhibition.city + ","
        exhibitionCountry.text = exhibition.country
        let days = calculateTimeDifference(from: exhibition.expirationDate)
        if Int(days) == 1 {
            exhibitionExpirationDate.text = "Trading ends today!"
        } else {
            exhibitionExpirationDate.text = "\(days) days left until closing"
        }
        DispatchQueue.global(qos: .utility).async {
            DispatchQueue.main.async {
                [self] in
                exhName.text = self.exhibitionName.text! + ".jpeg"
                netImage.image(with: exhName.text!) { [weak self] image in
                    self?.exhibitionImage.image = image
                }
            }
        }
        
    }
    
    func calculateTimeDifference(from dateTime1: String) -> String {
        let dateWithTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let date = dateFormatter.string(from: dateWithTime) // 2/10/17
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateAsString = dateTime1
        let date1 = dateFormatter.date(from: dateAsString)!
                                
        //let dateAsString2 = date
        let date2 = dateFormatter.date(from: date)!
        
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .year]
        let difference = (Calendar.current as NSCalendar).components(components, from: date2, to: date1, options: [])
        
        let dateTimeDifferenceString = "\(difference.day!)"
        
        //        if difference.day != 0 {
        //            dateTimeDifferenceString = "\(difference.day!)d \(difference.hour!)h \(difference.minute!)m"
        //        } else if  difference.day == 0 {
        //            dateTimeDifferenceString = "\(difference.hour!)h \(difference.minute!)m"
        //        }
        
        return dateTimeDifferenceString
        
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
