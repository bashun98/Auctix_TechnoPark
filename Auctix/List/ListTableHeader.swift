//
//  ListTableHeader.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit

class ListTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = "header"
    
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    private let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
    private var pickerData: [String] = []
    
    private let contatiner = UIView()
    private let arrow: String = " ▼"
    weak var buttonDelegate: HeaderOutput?
    weak var labelDelegate: HeaderOutput?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
      //  setupContentView()
        contentView.addSubview(textField)
        setupTextField()
        setupToolBar()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        //   setupButtons()
    }
    
    private func setupTextField() {
        textField.text = "Sort" + arrow
        textField.font = UIFont.get(with: .black, size: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
        textField.tintColor = .clear
        
    }
    private func setupToolBar() {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    public func configurePickerView(with data: [String]) {
        for i in 0...data.count - 1 {
            pickerData.append(data[i])
        }
    }
    
    func setupLabel(_ text: String) {
        textField.text = text + arrow
    }
    
    @objc
    private func doneTapped() {
        textField.resignFirstResponder()
        buttonDelegate?.doneButtonTapped()
    }
}

//MARK: - Picker View Delegate

extension ListTableHeader: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = pickerData[row]
        labelDelegate?.changeSortLabel(with: textField.text ?? "")
    }
}

//MARK: - Picker View DataSource

extension ListTableHeader: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}
