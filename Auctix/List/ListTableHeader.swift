//
//  ListTableHeader.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit

class ListTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = "header"
    
    //    private let textField: UITextField = {
    //        let textField = UITextField()
    //        textField.text = "Name"
    //        return textField
    //    }()
    //    private let picker = UIPickerView()
    
    //    private let sortButton: UIButton = {
    //        let button = UIButton()
    //        //button.setTitle("Name", for: .normal)
    //        button.titleLabel?.text = "Hello"
    //        button.setTitleColor(UIColor.blueGreen, for: .normal)
    //        return button
    //    }()
    
    private let headerLabel = UILabel()
    //    private let filterButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("Filter:", for: .normal)
    //        button.setTitleColor(UIColor.blueGreen, for: .normal)
    //        return button
    //    }()
    
    weak var delegate: HeaderOutput?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(headerLabel)
        headerLabel.text = "Name"
        headerLabel.font = UIFont(name: "Nunito-Black" , size: 14)
        //textField.inputView = picker
        //    contentView.addSubview(filterButton)
       // sortButton.addTarget(self, action: #selector(setupSort), for: .touchUpInside)
        // filterButton.addTarget(self, action: #selector(setupFilter), for: .touchUpInside)
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
        
        //        filterButton.snp.makeConstraints { make in
        //            make.trailingMargin.equalTo(contentView)
        //            make.bottom.equalTo(contentView)
        //        }
    }
    
    @objc private func sortButtonTapped() {
        delegate?.sortButtonTapped()
    }
    
    //    @objc private func setupFilter() {
    //        delegate?.filterButtonTapped()
    //    }
    //
    //    public func configure(with text: UILabel) {
    //
    //    }
}
