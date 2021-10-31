//
//  ListTableHeader.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit

class ListTableHeader: UITableViewHeaderFooterView {

    static let identifier = "header"
    
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sort:", for: .normal)
        button.setTitleColor(UIColor.blueGreen, for: .normal)
        return button
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filter:", for: .normal)
        button.setTitleColor(UIColor.blueGreen, for: .normal)
        return button
    }()
    
    weak var delegate: HeaderOutput?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(sortButton)
        contentView.addSubview(filterButton)
        sortButton.addTarget(self, action: #selector(setupSort), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(setupFilter), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtons()
    }
    
    private func setupButtons() {
        sortButton.snp.makeConstraints { make in
            make.leadingMargin.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        filterButton.snp.makeConstraints { make in
            make.trailingMargin.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    @objc private func setupSort() {
        delegate?.sortButtonTapped()
    }
    
    @objc private func setupFilter() {
        delegate?.filterButtonTapped()
    }
    
}
