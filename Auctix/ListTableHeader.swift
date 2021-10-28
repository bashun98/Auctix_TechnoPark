//
//  ListTableHeader.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit

class ListTableHeader: UITableViewHeaderFooterView {

    static let identifier = "TableHeader"
    
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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(sortButton)
        contentView.addSubview(filterButton)
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
    
}
