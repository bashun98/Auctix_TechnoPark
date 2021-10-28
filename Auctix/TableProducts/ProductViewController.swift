//
//  ProductViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 27.10.2021.
//

import Foundation
import UIKit
import PinLayout

protocol ProductViewControllerDelegate: AnyObject {
    func didTapChatButton(productViewController: UIViewController, productId: String, priceTextFild: String)
}

final class ProductViewController: UIViewController {
    var product: Product? {
        didSet {
            guard let product = product else {
                return
            }
            
            configure(with: product)
        }
    }
    
    private let changeButton = UIButton()
    private let productImageView = UIImageView()
    private let priceLabel = UILabel()
    private let titleLabel = UILabel()
    private let nowPrice = UILabel()
    private let currency = UILabel()
    private let priceChange = UIPickerView()
    private let priceFild = UITextField()
    private let question = UILabel()
    
    private var priceArray = ["","",""]
    private let screenWidth = UIScreen.main.bounds.width
    
    weak var delegate: ProductViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceChange.delegate = self
        priceChange.dataSource = self
        
        setupView()
        setupElement()
        setupNavBar()
        setupTextField()
        setupPrice()
        
        view.addSubview(titleLabel)
        view.addSubview(productImageView)
        view.addSubview(nowPrice)
        view.addSubview(currency)
        view.addSubview(priceLabel)
        view.addSubview(question)
        view.addSubview(priceFild)
        view.addSubview(changeButton)
        
    }
    
    func setupPrice() {
        var now = priceLabel.text ?? ""
        let nowNumStat = Int(now) ?? 0
        var nowNum: Int?
        var k = 100
        for i in 0...2 {
            nowNum = nowNumStat + k
            now = nowNum?.description ?? ""
            priceArray[i] = now
            k += 100
        }
        
    }
    
    
    func setupTextField() {
        
            // MARK: - картнка стереть
        priceFild.clearButtonMode = .whileEditing
        priceFild.font = .systemFont(ofSize: 20)
        priceFild.placeholder = "New price..."
        priceFild.layer.cornerRadius = 10
            // TODO: В константу цвет (так точно)
        priceFild.layer.backgroundColor = UIColor.searchColor.cgColor
        priceFild.translatesAutoresizingMaskIntoConstraints = false
        priceFild.inputView = priceChange
        priceFild.textAlignment = .center
        
    }
    
    
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupNavBar(){
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setupElement(){
        changeButton.backgroundColor = UIColor.blueGreen
        changeButton.layer.cornerRadius = 8
        changeButton.setTitle("Place a bet", for: .normal)
        changeButton.addTarget(self, action: #selector(didTapChangeButton), for: .touchUpInside)
        changeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.font = .systemFont(ofSize: 24, weight: .regular)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        
        nowPrice.font = .systemFont(ofSize: 24, weight: .regular)
        nowPrice.translatesAutoresizingMaskIntoConstraints = false
        nowPrice.text = "Current price:"
        
        currency.font = .systemFont(ofSize: 24, weight: .regular)
        currency.translatesAutoresizingMaskIntoConstraints = false
        currency.text = "$"
        
        question.font = .systemFont(ofSize: 24, weight: .regular)
        question.translatesAutoresizingMaskIntoConstraints = false
        question.text = "Want to place a bet?"
        
        priceChange.translatesAutoresizingMaskIntoConstraints = false
        
        //priceFild.font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    func configure(with product: Product) {
        productImageView.image = product.productImg
        titleLabel.text = product.title
        priceLabel.text = product.cost
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayuot()
    }
    
    func setupLayuot(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
//            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            productImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
//            productImageView.heightAnchor.constraint(equalToConstant: 300),
//
            nowPrice.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nowPrice.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            priceLabel.leadingAnchor.constraint(equalTo: nowPrice.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
        
            currency.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 1),
            currency.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            question.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            question.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            question.topAnchor.constraint(equalTo: nowPrice.bottomAnchor, constant: 10),
            
            priceFild.heightAnchor.constraint(equalToConstant: 50),
            priceFild.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            priceFild.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            priceFild.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 10),
            
            changeButton.heightAnchor.constraint(equalToConstant: 40),
            changeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            changeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            changeButton.topAnchor.constraint(equalTo: priceFild.bottomAnchor, constant: 10),
            
            
        ])
    }
    
    @objc
    private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapChangeButton() {
        guard let productId = product?.id else {
            return
        }
        delegate?.didTapChatButton(productViewController: self, productId: productId, priceTextFild: priceFild.text ?? "")
    }
}

extension ProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return priceArray.count
    }
}

extension ProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priceArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priceFild.text = priceArray[row]
        priceFild.resignFirstResponder()
    }
}

//extension ProductViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn
//      range: NSRange, replacementString string: String) -> Bool {
//
//        if textField.text?.count == 0 && string == "0" {
//            return false
//        }
//        return string == string.filter("0123456789".contains)
//    }
//}
