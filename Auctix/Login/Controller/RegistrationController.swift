//
//  RegistrationController.swift
//  Auctix
//
//  Created by mac on 04.11.2021.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: Properties
    
    private let iconImage = UIImageView(image: UIImage(named: "Image3"))
    private let auctixLabel = UILabel()
    private let singUpLabel = UILabel()
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Fullname")
    
    private let passwordTextFiel: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()

    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.title = "Sign Up"
        return button
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blueGreen, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        let attriburedTitle = NSMutableAttributedString(string: "Log In ",
                                                        attributes: atts)
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(showLoginController), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: Selectors
    
    @objc func handleSignUp() {
        
    }
    
    @objc func showLoginController() {
            //back action controller
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helpers
    
    func configureUI() {
        view.backgroundColor = .white

        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 120, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(auctixLabel)
        auctixLabel.text = "Auctix"
        auctixLabel.textColor = UIColor.blueGreen
        auctixLabel.centerX(inView: view)
        auctixLabel.anchor(top: iconImage.bottomAnchor, paddingTop: 20)
        
        view.addSubview(logInButton)
        view.addSubview(singUpLabel)
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        singUpLabel.attributedText = underlineAttributedString
        singUpLabel.text = "Sign Up"
        singUpLabel.font = UIFont.boldSystemFont(ofSize: 16)
        singUpLabel.textColor = UIColor.blueGreen
        
        logInButton.anchor(top: auctixLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 32, paddingLeft: 32)
        singUpLabel.anchor(top: auctixLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 32, paddingRight: 32)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,
                                                   passwordTextFiel,
                                                   fullnameTextField,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: logInButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
    }
}
