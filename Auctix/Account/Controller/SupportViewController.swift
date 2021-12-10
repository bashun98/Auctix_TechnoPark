//
//  SupportViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 09.12.2021.
//

import UIKit
import Firebase
import MessageUI

class SupportViewController: UIViewController {
    
    private let iconImage = UIImageView(image: UIImage(named: "Image3"))
    private let messageLabel = UILabel()
    private let message = UITextView()
    var activeTextView : UITextView? = nil
    private let messageButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.addTarget(self, action: #selector(sendEmailController), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.title = "Send"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addSub()
        setupElement()
        setupLayuot()
        setupDelegate()
        registerForKeyboardNotifications()
    }
    
    func setupDelegate(){
        message.delegate = self
    }
    
    func addSub() {
        view.addSubview(iconImage)
        view.addSubview(messageLabel)
        view.addSubview(message)
        view.addSubview(messageButton)
    }
    
    func setupElement() {
        messageLabel.text = "Write your question and click on the button. Your appeal will be sent to mail - shiga2001@mail.ru -. Then we will contact you!"
        messageLabel.textColor = UIColor.lightCornflowerBlue
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 20)
        
        message.returnKeyType = .done
        message.keyboardAppearance = .light
        message.layer.borderWidth = 1
        message.layer.borderColor = UIColor.lightCornflowerBlue.cgColor
        message.layer.cornerRadius = 10
        message.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        message.keyboardDismissMode = .onDrag
        message.text = "Your message"
        message.font = UIFont(name: "Nutino-Regular", size: 14.0)
        message.textColor = UIColor.lightGray
        
        //iconImage.center = self.view.center
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLayuot(){
        NSLayoutConstraint.activate([
            iconImage.heightAnchor.constraint(equalToConstant: 120),
            iconImage.widthAnchor.constraint(equalToConstant: 120),
            iconImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            iconImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIScreen.main.bounds.width/2 - 60),
            iconImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(UIScreen.main.bounds.width/2 - 60)),
            
            messageLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            //messageLabel.heightAnchor.constraint(equalToConstant: 300),

            message.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            message.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            message.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            message.heightAnchor.constraint(equalToConstant: 200),
            
            messageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            messageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            messageButton.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 10),
            messageButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.view.tintColor = UIColor.blueGreen
    }
    
    func setupNavBarHiden() {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @objc
    func sendEmailController() {
        let mailComposeViewComtroller = configureMailComposer()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewComtroller, animated: true, completion: nil)
        } else {
            print("No dostup k iCloud")
        }
    }
}

extension SupportViewController: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        if message.text == "" {
            message.text = "Your message"
            message.font = UIFont(name: "Nutino-Regular", size: 14.0)
            message.textColor = UIColor.lightGray
        }

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if message.text == "Your message" {
            message.text = ""
            message.font = UIFont(name: "Nutino-Regular", size: 18.0)
            message.textColor = UIColor.blueGreen
        }
        self.activeTextView = textView

    }
    
//    private func textViewDidEndEditing(_ textView: UITextView) -> Bool {
//        if message.text == "" {
//            message.text = "Your message"
//            message.font = UIFont(name: "Nutino-Regular", size: 14.0)
//            message.textColor = UIColor.lightGray
//        }
//
//        return true
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            message.resignFirstResponder()
        }
        return true
    }
}

extension SupportViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SupportViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SupportViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
           return
        }

        var shouldMoveView = false
        
        if let activeTextView = activeTextView {
            let bottomOfTextField = activeTextView.convert(activeTextView.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if activeTextView == message {
                if bottomOfTextField > topOfKeyboard {
                    shouldMoveView = true
                }
            }
        }
        
        if(shouldMoveView) {
            self.view.frame.origin.y = 0 - keyboardSize.height/12
        }

    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

extension SupportViewController: MFMailComposeViewControllerDelegate {
    func configureMailComposer() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        guard let email = message.text else { return mailComposerVC }
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["shiga2001@mail.ru"])
        mailComposerVC.setSubject("Сообщение от \(Auth.auth().currentUser?.email ?? "")")
        mailComposerVC.setMessageBody("\(email)", isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
