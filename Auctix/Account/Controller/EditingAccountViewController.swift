//
//  EditingAccountViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 14.11.2021.
//

import UIKit
import Firebase

protocol UserControllerInput: AnyObject {
    func didReceive(_ users: [User])
}

class EditingAccountViewController: UIViewController {

    var activeTextField : UITextField? = nil
    
    private var users: [User] = []
    
    private let user = Auth.auth().currentUser
    
    private let imageView = UIImageView()
    private var emailVerificaionTitle: UILabel = {
        let tf = UILabel()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = UIColor.lightCornflowerBlue
        tf.textAlignment = .center
        return tf
    }()
    
    private let numberTextField: CustomTextField = {
    let tf = CustomTextField(placeholder: "Phone")
        tf.returnKeyType = .done
        tf.textContentType = .telephoneNumber
        tf.keyboardType = .numberPad
        tf.keyboardAppearance = .light
        tf.addDoneCanselToolBar()
        return tf
    }()
    
    private let cityTextField: CustomTextField = {
    let tf = CustomTextField(placeholder: "City")
        tf.returnKeyType = .done
        tf.textContentType = .addressCity
        tf.keyboardAppearance = .light
        return tf
    }()
    
    private let fullnameTextField: CustomTextField = {
    let tf = CustomTextField(placeholder: "Fullname")
        tf.returnKeyType = .done
        tf.textContentType = .name
        tf.keyboardAppearance = .light
        return tf
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "email")
        tf.returnKeyType = .done
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        tf.keyboardAppearance = .light
        return tf
    }()

    private let editionButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.title = "Edit"
        return button
    }()
    
    private var textFildButtonStack = UIStackView()
    
    private let custumAlert = CustomAlert()
    
    //для форматирования строки телефона
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    private let model: UserModelDescription = UserModel()
    
    let loadingIndicator: ProgressView = {
            let progress = ProgressView(colors: [.red, .systemGreen, .systemBlue], lineWidth: 5)
            progress.translatesAutoresizingMaskIntoConstraints = false
            return progress
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        registerForKeyboardNotifications()
        setupImage()
        setupEmailVerLabel()
        configureUI()
        setupDelegate()
        setupLayout()
        setupModel()
        loadingIndicator.animateStroke()
        loadingIndicator.animateRotation()
//        setupModel()
    }
    
    private func setupModel() {
        model.loadUsers()
        model.output = self
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.view.tintColor = UIColor.blueGreen
    }
    
    func setupNavBarHiden() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func configure() {
        //productImageView.image = product.productImg
        fullnameTextField.text = users[0].name
        emailTextField.text = users[0].email
        cityTextField.text = users[0].city
        numberTextField.text = users[0].phone
        
    }
    
    func setupEmailVerLabel(){
        Auth.auth().currentUser?.reload()
        let user = Auth.auth().currentUser
        if (user != nil && user!.isEmailVerified) {
            emailVerificaionTitle.text = " "
            emailVerificaionTitle.text = "Account verified"
        } else {
            emailVerificaionTitle.text = "Account not verified"
        }
    }
    
    func setupDelegate(){
        cityTextField.delegate = self
        fullnameTextField.delegate = self
        numberTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func setupImage(){
        addPhoto()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
        imageView.makeRounded()
    }
    
    //MARK: Selectors

    @objc func handleUpdate() {
        let name = fullnameTextField.text!
        let email = emailTextField.text!
        let number = numberTextField.text!
        let city = cityTextField.text!
        if (!name.isEmpty && !email.isEmpty && !number.isEmpty && !city.isEmpty) {
            users[0].name = name
            users[0].email = email
            users[0].phone = number
            users[0].city = city
            if email != Auth.auth().currentUser?.email {
                Auth.auth().currentUser?.updateEmail(to: email) { error in
                    if (error != nil) {
                        //если ошибка
                    } else {
                        //если все хорошо
                    }
                }
            }
            model.update(user: users[0])
            fullnameTextField.text = ""
            emailTextField.text = ""
            numberTextField.text = ""
            cityTextField.text = ""
            //self.custumAlert.showAlert(title: "Ready", message: "Your data has been successfully updated", viewController: self)
            setupNavBarHiden()
            navigationController?.popToRootViewController(animated: true)
        } else {
            self.custumAlert.showAlert(title: "Error", message: "Not all fields were entered correctly", viewController: self)
        }
    }
    
    
    func setupStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [fullnameTextField,
                                                   emailTextField,
                                                   numberTextField,
                                                   cityTextField,
                                                   editionButton])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.addSubview(loadingIndicator)
        loadingIndicator.tag = 35
        
        view.addSubview(emailVerificaionTitle)
        
        textFildButtonStack = setupStack()
        textFildButtonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFildButtonStack)
        
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width/3),
            imageView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width/3),
            imageView.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.width/3),
            imageView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            emailVerificaionTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            emailVerificaionTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emailVerificaionTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textFildButtonStack.topAnchor.constraint(equalTo: emailVerificaionTitle.bottomAnchor, constant: 16),
            textFildButtonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            textFildButtonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            loadingIndicator.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 47),
            loadingIndicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: -47),
            loadingIndicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -47),
            loadingIndicator.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 47),
            
            
        ])
    }
        
    //для форматирования строки телефона
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
               
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
            
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        if number.count == 1 {
            return "+" + "7"
        } else {
            return "+" + number
        }
    }
}

extension EditingAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        fullnameTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTextField {
            let fullString = (textField.text ?? "") + string
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            return false
        } else {
        return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
}

extension EditingAccountViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
           return
        }
        
        var shouldMoveViewUpCity = false
        var scholdMoveViewUpNum = false
        
        // if active text field is not nil
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if activeTextField == cityTextField {
                if bottomOfTextField > topOfKeyboard {
                    shouldMoveViewUpCity = true
                }
            }
            if activeTextField == numberTextField {
                if bottomOfTextField > topOfKeyboard {
                    scholdMoveViewUpNum = true
                }
            }
        }
        
        if(shouldMoveViewUpCity) {
            self.view.frame.origin.y = 0 - keyboardSize.height/3
        }
        if(scholdMoveViewUpNum) {
            self.view.frame.origin.y = 0 - keyboardSize.height/8
        }

    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

extension EditingAccountViewController: UserControllerInput {
    func didReceive(_ users: [User]) {
        self.users = users.compactMap {
            if $0.id == Auth.auth().currentUser?.uid {
                     return $0
                 } else {
                     return nil
                 }
             }
        configure()
    }
}


extension EditingAccountViewController {
    func addPhoto() {
        let userId = Auth.auth().currentUser?.uid ?? ""

        let islandRef = Storage.storage().reference().child("UsersPhoto").child("\(userId)")

        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
              self.imageView.image = #imageLiteral(resourceName: "UserDefault")
              self.view.viewWithTag(35)?.removeFromSuperview()
          } else {
              guard let data = data else { return }
              let image = UIImage(data: data)
              self.imageView.image = image
              self.view.viewWithTag(35)?.removeFromSuperview()
          }
        }
    }
}
