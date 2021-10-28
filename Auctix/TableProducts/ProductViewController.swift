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
    func didTapChatButton(productViewController: UIViewController, productId: String)
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
    
    private let chatButton = UIButton()
    private let productImageView = UIImageView()
    private let priceLabel = UILabel()
    private let titleLabel = UILabel()
    private let nowPrice = UILabel()
    private let currency = UILabel()
    private let priceChange = UIPickerView()
    private let question = UILabel()
    
    private let screenWidth = UIScreen.main.bounds.width
    
    weak var delegate: ProductViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupElement()
        setupNavBar()
        view.addSubview(titleLabel)
        view.addSubview(productImageView)
        view.addSubview(nowPrice)
        view.addSubview(currency)
        view.addSubview(priceLabel)
        view.addSubview(question)
        view.addSubview(priceChange)
    }
    
    
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupNavBar(){
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setupElement(){
        chatButton.backgroundColor = .systemIndigo
        chatButton.layer.cornerRadius = 8
        chatButton.setTitle("Chat", for: .normal)
        chatButton.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
        chatButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        
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
            
            nowPrice.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nowPrice.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            priceLabel.leadingAnchor.constraint(equalTo: nowPrice.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
        
            currency.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 1),
            currency.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            question.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            question.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            question.topAnchor.constraint(equalTo: nowPrice.bottomAnchor, constant: 10),
            
            priceChange.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            priceChange.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            priceChange.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 10),
            
            
        ])
    }
    
    @objc
    private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapChatButton() {
        guard let productId = product?.id else {
            return
        }
        //xchtooooo
        delegate?.didTapChatButton(productViewController: self, productId: productId)
    }
}
