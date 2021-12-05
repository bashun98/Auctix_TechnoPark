//
//  ListTableHeader.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit

final class ListTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = "ListTableHeader"
    
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    private let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
    private var pickerData: [String] = []
    
    private let contatiner = UIView()
    private let arrow: String = " ▼"
    weak var output: HeaderOutput?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addMyView()
        setupTextField()
        setupToolBar()
        pickerViewDataAndSourse()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTextFieldLayout()
    }
    
    private func addMyView() {
        contentView.addSubview(textField)
    }
    
    private func pickerViewDataAndSourse() {
        pickerView.delegate = self
        pickerView.dataSource = self
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
    
    private func setupTextFieldLayout() {
        textField.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
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
        pickerData = data
    }
  
    private func handleSelect(row: Int) {
        let text = pickerData[row]
        textField.text = text + arrow
        output?.changeSortLabel(with: text)
    }
    
    @objc
    private func doneTapped() {
        textField.resignFirstResponder()
        if pickerView.selectedRow(inComponent: 0) == 0 {
            handleSelect(row: 0)
        }
        output?.doneButtonTapped()
    }
}

//MARK: - Picker View Delegate

extension ListTableHeader: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        handleSelect(row: row)
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
