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
import SDWebImage

protocol ProductViewControllerDelegate: AnyObject {
    func didTapChatButton(productViewController: UIViewController, productName: String, priceTextFild: String, currentPrice: String)
}

class ProductViewController: UIViewController {
    var product: Product? {
        didSet {
            guard let product = product else {
                return
            }
            configure(with: product)
        }
    }
    
    private let changeButton = UIButton(type: .system)
    private let priceLabel = UILabel()
    private let titleLabel = UILabel()
    private let nowPrice = UILabel()
    private let currency = UILabel()
    private let priceFild = UITextField()
    private let question = UILabel()
    //private let emailLabel = UILabel()
    private var flag: Bool?
    private var flagAuth: Bool?
    
    private var productUrl = UILabel()
    var productImageView = UIImageView()
        
    private var priceArray = ["","",""]
    private let screenWidth = UIScreen.main.bounds.width
    
    weak var delegate: ProductViewControllerDelegate?
    
    private var imageLoader = ProductImageLoader.shared
    
    var activeTextField : UITextField? = nil
    
    public var custumAlert = CustomAlert()
    
    var flagActiv: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayuot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAuth()
        sendVerificationMail()
        setupNavBar()
        setupPrice()
        setupTextField()
        setupAddition()
        setupView()
    }
    
    public func reloadUI() {
        super.reloadInputViews()
        setupAuth()
        sendVerificationMail()
    }
 
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
    }
    
    func setupPrice() {
        var now = priceLabel.text ?? ""
        let nowNumStat = Int(now) ?? 0
        var nowNum: Int?
        var k = 1000
        for i in 0...1 {
            nowNum = nowNumStat + k
            now = nowNum?.description ?? ""
            priceArray[i] = now
            k += 1000
        }
    }
    
    func setupTextField() {
            // MARK: - картнка стереть
        priceFild.clearButtonMode = .whileEditing
        priceFild.delegate = self
        priceFild.font = .systemFont(ofSize: 20)
        priceFild.placeholder = "New price..."
        priceFild.layer.cornerRadius = 10
        priceFild.layer.backgroundColor = UIColor.searchColor.cgColor
        priceFild.translatesAutoresizingMaskIntoConstraints = false
        priceFild.keyboardType = .numberPad
        priceFild.addDonePriceToolBar(array: priceArray)
        priceFild.textAlignment = .center
    }
    
    func setupView() {
        view.backgroundColor = UIColor.background
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
        changeButton.setTitleColor(.white, for: .normal)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
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

        productImageView.translatesAutoresizingMaskIntoConstraints = false
        if flagActiv ?? true {
            if flag ?? false {
                question.text = "Want to place a bet?"
                question.textAlignment = .left
                priceFild.isHidden = false
                changeButton.addTarget(self, action: #selector(didTapChangeButton), for: .touchUpInside)
                
            } else {
                question.text = "Sign in to change the price"
                question.textAlignment = .left
                priceFild.isHidden = true
                changeButton.setTitle("Sign in", for: .normal)
                changeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
                changeButton.addTarget(self, action: #selector(didTapRegistrButton), for: .touchUpInside)
            }
            if flagAuth == false {
                question.text = "Your mail is not confirmed. Check your mail!"
                question.textAlignment = .center
                priceFild.isHidden = true
                changeButton.isHidden = true
                changeButton.isEnabled = false
            }
        } else {
            question.text = "The exhibition is closed. A letter was sent to the winner about the possibility of redemption of the goods!"
            question.textAlignment = .center
            priceFild.isHidden = true
            changeButton.isHidden = true
            changeButton.isEnabled = false
        }
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.name
        priceLabel.text = String(product.currentPrice)
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
    private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapChangeButton() {
        guard let productName = product?.name else {
            return
        }
        delegate?.didTapChatButton(productViewController: self, productName: productName, priceTextFild: priceFild.text ?? .init(), currentPrice: priceLabel.text ?? .init())
    }
    
    @objc
    private func didTapRegistrButton() {
        let viewController = RegistrationController()
        viewController.productController = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension UITextField {
    
    func addDonePriceToolBar(array: [String], onDone: (target: Any, action: Selector)? = nil, onFirstPrice: (target: Any, action: Selector)? = nil, onSecondPrice: (target: Any, action: Selector)? = nil) {
        let array = array
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        let onFirstPrice = onFirstPrice ?? (target: self, action: #selector(firstPriceButtonTapped(_ :)))
        let onSecondPrice = onSecondPrice ?? (target: self, action: #selector(secondPriceButtonTapped(_ :)))
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolBar.barStyle = .default
        toolBar.items = [
            UIBarButtonItem(title: "\(array[0])", style: .plain, target: onFirstPrice.target, action: onFirstPrice.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "\(array[1])", style: .plain, target: onSecondPrice.target, action: onSecondPrice.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: onDone.target, action: onDone.action)
        ]
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }
    
    @objc
    func firstPriceButtonTapped(_ sender: UIBarButtonItem) {
        self.text = sender.title
        self.resignFirstResponder()
    }
    
    @objc
    func secondPriceButtonTapped(_ sender: UIBarButtonItem) {
        self.text = sender.title
        self.resignFirstResponder()
    }
}


extension ProductViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProductViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProductViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
           return
        }
        
        var shouldMoveViewUp = false
        
        // if active text field is not nil
        if let activeTextField = activeTextField {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            shouldMoveViewUp = bottomOfTextField > topOfKeyboard ? true : false
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height/8
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
 
}

extension ProductViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }

}
