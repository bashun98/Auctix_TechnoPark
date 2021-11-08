//
//  ResetPasswordController.swift
//  Auctix
//
//  Created by mac on 04.11.2021.
//

import UIKit
import Firebase

class ResetPasswordController: UIViewController {
    
    //MARK: Properties
    
    private let iconImage = UIImageView(image: UIImage(named: "Image3"))
    
    private let auctixLabel = UILabel()

    private let attentionLabel = UILabel()
    
    private let messageLabel = UILabel()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "email")
        tf.returnKeyType = .done
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        return tf
    }()
    
    private let resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.title = "Send Reset Link"
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.blueGreen
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    private let custumAlert = CustomAlert()
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        configureUI()

    }
    
    //MARK: Selectors
    @objc func handleResetPassword() {
        let email = emailTextField.text!
        if (!email.isEmpty){
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    //если есть какая-то ошибка отправки сообщения
                }
            }
        }else{
            self.custumAlert.showAlert(title: "Error", message: "Not all fields were entered correctly", viewController: self)
        }
    }
    
    @objc func handleDismissal() {
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
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,
                                                   resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: auctixLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(attentionLabel)
        attentionLabel.text = "Attention!!!"
        attentionLabel.textColor = UIColor.blueGreen
        attentionLabel.centerX(inView: view)
        attentionLabel.font = .systemFont(ofSize: 30)
        attentionLabel.anchor(top: stack.bottomAnchor, paddingTop: 20)
        
        view.addSubview(messageLabel)
        messageLabel.text = "After clicking on the button, you will receive a message by e-mail with a changed password. Don't forget to check your email!"
        messageLabel.textColor = UIColor.lightCornflowerBlue
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 20)
        messageLabel.centerX(inView: view)
        //messageLabel.anchor(top: attentionLabel.bottomAnchor, paddingTop: 10)
        messageLabel.anchor(top: attentionLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 50, paddingRight: 30)

        
    }
}
extension ResetPasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
}
