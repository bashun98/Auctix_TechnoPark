//
//  ProductViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 27.10.2021.
//

import Foundation
import UIKit
import PinLayout
import Firebase

protocol ProductViewControllerDelegate: AnyObject {
    func didTapChatButton(productViewController: UIViewController, productName: String, priceTextFild: String)
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
    private var flag: Bool?
    private var flagAuth: Bool?
        
    private let toolBar = UIToolbar()
    private let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
    
    private var priceArray = ["","",""]
    private let screenWidth = UIScreen.main.bounds.width
    
    weak var delegate: ProductViewControllerDelegate?
    
    private var netImage = ExhibitionsImageLoader.shared
    private let productName = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceChange.delegate = self
        priceChange.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAuth()
        sendVerificationMail()
        setupNavBar()
        setupTextField()
        setupPrice()
        setupAddition()
        setupView()
    }
    
    public func reloadUI() {
        super.reloadInputViews()
        setupAuth()
        sendVerificationMail()
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        viewWillAppear(true)
//    }
    
    func setupAuth() {
        let user = Auth.auth().currentUser
        if user == nil {
            flag = false
        } else {
            flag = true
        }
    }
    // длф Вовы, данная функция проверяет, подтверждена ли почта
    func sendVerificationMail() {
        let authUser = Auth.auth().currentUser
        if authUser != nil && !authUser!.isEmailVerified {
            flagAuth = false
        }
        else {
            //если адрес почты подтвержден
            flagAuth = true
        }
        setupElement()
    }
    
    func setupAddition(){
        view.addSubview(titleLabel)
        view.addSubview(productImageView)
        productImageView.contentMode = .scaleAspectFit
        view.addSubview(nowPrice)
        view.addSubview(currency)
        view.addSubview(priceLabel)
        view.addSubview(question)
        view.addSubview(priceFild)
        view.addSubview(changeButton)
        toolBar.setItems([doneButton], animated: false)
        //priceChange.addSubview(toolBar)
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
        priceFild.layer.backgroundColor = UIColor.searchColor.cgColor
        priceFild.translatesAutoresizingMaskIntoConstraints = false
        priceFild.inputView = priceChange
        priceFild.inputAccessoryView = toolBar
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
        changeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        changeButton.addTarget(self, action: #selector(didTapChangeButton), for: .touchUpInside)
        
        priceLabel.font = .systemFont(ofSize: 24, weight: .regular)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = UIColor.honeyYellow
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.honeyYellow
        
        nowPrice.font = .systemFont(ofSize: 24, weight: .regular)
        nowPrice.translatesAutoresizingMaskIntoConstraints = false
        nowPrice.text = "Current price:"
        nowPrice.textColor = UIColor.lightCornflowerBlue
        
        currency.font = .systemFont(ofSize: 24, weight: .regular)
        currency.translatesAutoresizingMaskIntoConstraints = false
        currency.text = "$"
        currency.textColor = UIColor.honeyYellow
        
        question.font = .systemFont(ofSize: 24, weight: .regular)
        question.translatesAutoresizingMaskIntoConstraints = false
        question.textColor = UIColor.lightCornflowerBlue
        question.numberOfLines = 0
        
        priceChange.backgroundColor = .white
        priceChange.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.backgroundColor = .systemGray
        toolBar.sizeToFit()

        doneButton.tintColor = UIColor.blueGreen

        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if flag ?? false {
            question.text = "Want to place a bet?"
            priceFild.isHidden = false
//            if Auth.auth().currentUser?.uid == product?.currentIdClient {
//                question.text = "The last price is yours. As soon as it changes, we will let you know!"
//                priceFild.isHidden = true
//                changeButton.isEnabled = false
//                changeButton.setTitle("View other products", for: .normal)
//                changeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//            }
            //doneButton.customView?.isHidden = false
            
        } else {
            question.text = "Sign in to change the price"
            priceFild.isHidden = true
            changeButton.isEnabled = false
            changeButton.setTitle("Go to account page", for: .normal)
            changeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        }
        if flagAuth == false {
            question.text = "Your mail is not confirmed"
            priceFild.isHidden = true
            changeButton.isEnabled = false
            changeButton.setTitle("Check your mail", for: .normal)
            changeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        }
    }
    
    func configure(with product: Product) {
        //productImageView.image = product.productImg
        titleLabel.text = product.name
        priceLabel.text = String(product.currentPrice)
        productName.text = product.name + ".jpeg"
        netImage.image(with: productName.text!) { [weak self] image in
            self?.productImageView.image = image
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayuot()
    }
    
    func setupLayuot(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            productImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 300),

            nowPrice.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nowPrice.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
            
            priceLabel.leadingAnchor.constraint(equalTo: nowPrice.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
        
            currency.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 1),
            currency.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
            
            question.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            question.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            question.topAnchor.constraint(equalTo: currency.bottomAnchor, constant: 10),
            
            priceFild.heightAnchor.constraint(equalToConstant: 50),
            priceFild.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            priceFild.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            priceFild.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 10),
            
            changeButton.heightAnchor.constraint(equalToConstant: 50),
            changeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            changeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            changeButton.topAnchor.constraint(equalTo: priceFild.bottomAnchor, constant: 10),
        ])
    }
    
    @objc
    func loginButtonTapped(sender: UIButton){
        navigationController?.pushViewController(LoginController(), animated: false)
    }
    
    @objc
    func doneButtonTapped() {
        priceFild.resignFirstResponder()
    }
    
    @objc
    private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapChangeButton() {
        guard let productName = product?.name else {
            return
        }
        delegate?.didTapChatButton(productViewController: self, productName: productName, priceTextFild: priceFild.text ?? "")
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
    }
}

