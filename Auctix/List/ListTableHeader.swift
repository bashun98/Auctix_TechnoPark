//
//  ListTableHeader.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit

class ListTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = "header"
    private let headerLabel = UILabel()
    weak var delegate: HeaderOutput?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(headerLabel)
        headerLabel.text = "Name"
        headerLabel.font = UIFont(name: "Nunito-Black" , size: 18)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sortButtonTapped))
        headerLabel.isUserInteractionEnabled = true
        headerLabel.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtons()
    }
    
    func setupLabel(_ text: String) {
        headerLabel.text = text
    }
    
    private func setupButtons() {
        headerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    @objc private func sortButtonTapped() {
        delegate?.sortButtonTapped()
    }
}
