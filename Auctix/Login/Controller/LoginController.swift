//
//  LoginController.swift
//  Auctix
//
//  Created by mac on 04.11.2021.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    // MARK: Properties
    
    private let iconImage = UIImageView(image: UIImage(named: "Image3"))
    private let auctixLabel = UILabel()
    private let logInLabel = UILabel()
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "email")
        tf.returnKeyType = .done
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        return tf
    }()
    private let passwordTextFiel: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.returnKeyType = .done
        tf.textContentType = .password
        tf.isSecureTextEntry = true
        return tf
    }()

    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.title = "Log In"
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blueGreen, .font: UIFont.systemFont(ofSize: 15)]
        
        let attriburedTitle = NSMutableAttributedString(string: "Forgot your password? ",
                                                        attributes: atts)
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blueGreen, .font: UIFont.boldSystemFont(ofSize: 15)]
        attriburedTitle.append(NSAttributedString(string: "Get help signing in.", attributes: boldAtts))
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(showForgotPassword), for: .touchUpInside)
        
        return button
    }()
    
    private let dividerView = DividerView()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blueGreen, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        let attriburedTitle = NSMutableAttributedString(string: "Sign Up ",
                                                        attributes: atts)
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(showRegistrationController), for: .touchUpInside)
        
        return button
    }()
    
    private let custumAlert = CustomAlert()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        configureUI()
    }
    
    func setupDelegate(){
        passwordTextFiel.delegate = self
        emailTextField.delegate = self
    }
    //MARK: Selectord
    
    @objc func handleLogin() {
        let email = emailTextField.text!
        let password = passwordTextFiel.text!
        Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
            if error != nil {
                print("loh")
                self.custumAlert.showAlert(title: "Error", message: "We entered an incorrect password or mail", viewController: self)
            } else {
                print("norm")
                self.navigationController?.popToRootViewController(animated: false)
                
            }
            print("DEBUG: Handle login")
        }
    }
    
    @objc func showForgotPassword() {
        let controller = ResetPasswordController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func showRegistrationController() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Helpers
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black

        view.backgroundColor = .white

        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 120, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(auctixLabel)
        auctixLabel.attributedText = getAttrTitle()
        auctixLabel.centerX(inView: view)
        auctixLabel.anchor(top: iconImage.bottomAnchor, paddingTop: 20)
        
        let signUpLoginStack = UIStackView(arrangedSubviews: [logInLabel,
                                                             signUpButton])
        signUpLoginStack.axis = .horizontal
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        logInLabel.attributedText = underlineAttributedString
        logInLabel.text = "Log In"
        logInLabel.font = UIFont.boldSystemFont(ofSize: 16)
        logInLabel.textColor = UIColor.blueGreen
        view.addSubview(signUpLoginStack)
        signUpLoginStack.anchor(top: auctixLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,
                                                   passwordTextFiel,
                                                   loginButton,
                                                   forgotPasswordButton,
                                                   dividerView])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: signUpLoginStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
}
extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextFiel.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
}
