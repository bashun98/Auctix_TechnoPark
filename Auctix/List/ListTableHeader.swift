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
    private let contatiner = UIView()
    private let arrow: String = " ▼"
    weak var delegate: HeaderOutput?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupHeaderLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtons()
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .white
        contentView.addSubview(headerLabel)
    }
    
    private func setupHeaderLabel() {
        headerLabel.text = "Name" + arrow
        headerLabel.font = UIFont(name: "Nunito-Black" , size: 18)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sortButtonTapped))
        headerLabel.isUserInteractionEnabled = true
        headerLabel.addGestureRecognizer(tap)
    }
    
    private func setupButtons() {
        headerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(contentView)
        }
    }
    
    func setupLabel(_ text: String) {
        headerLabel.text = text + arrow
    }
    
    @objc private func sortButtonTapped() {
        delegate?.sortButtonTapped()
    }
}
