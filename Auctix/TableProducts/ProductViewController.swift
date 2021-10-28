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
    
    private let screenWidth = UIScreen.main.bounds.width
    
    weak var delegate: ProductViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElement()
        setupNavBar()
        [productImageView, titleLabel, nowPrice, currency, priceChange, priceLabel, chatButton].forEach {
            view.addSubview($0)
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
        
        nowPrice.font = .systemFont(ofSize: 24, weight: .regular)
        nowPrice.translatesAutoresizingMaskIntoConstraints = false
        nowPrice.text = "Current price:"
        
        currency.font = .systemFont(ofSize: 24, weight: .regular)
        currency.translatesAutoresizingMaskIntoConstraints = false
        currency.text = "$"
        
        }
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
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ((screenWidth - 300) / 2)),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -((screenWidth - 300) / 2)),
            
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            productImageView.heightAnchor.constraint(equalToConstant: 300),
            
            nowPrice.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nowPrice.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
            
            priceLabel.leadingAnchor.constraint(equalTo: nowPrice.leadingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
            
            currency.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: 1),
            currency.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
            currency.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -1),
            
            
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
