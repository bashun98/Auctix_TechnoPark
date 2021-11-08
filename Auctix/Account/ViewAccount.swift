//
//  ViewAccount.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 06.11.2021.
//

import Firebase
import UIKit

protocol GoFuncAccount: AnyObject {
    func logoutButtonTapped(sender: UIButton)
}

class ViewAccount: UIView, UITableViewDelegate, UITableViewDataSource{
    
    weak var delegate: GoFuncAccount?
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 33/255, green: 158/255, blue: 188/255, alpha: 1), .font: UIFont.boldSystemFont(ofSize: 16)]
        
        let attriburedTitle = NSMutableAttributedString(string: "Log Out",
                                                        attributes: atts)
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingTableViewCell.self,
                       forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alwaysBounceVertical = false
        
        table.register(SwitchTableViewCell.self,
                       forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    var image = UIImageView()
    var userNameTitle = UILabel()
    var emailVerificaionTitle = UILabel()
    let appearance = UINavigationBarAppearance()
    let viewAuth = ViewAuth()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAccView()
    }
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    
    func setupAccView(){
        addSubview(loginButton)
        loginButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16)
        
        setupNavigationTitle()
        
        setupImage()
        addSubview(image)
        
        setupUserNameLabel()
        addSubview(userNameTitle)
        
        addSubview(emailVerificaionTitle)
        setupEmailVerLabel()
        
        addSubview(tableView)
        setupTable()
        addConstraints()
    }
    @objc
    func logoutButtonTapped() {
        delegate?.logoutButtonTapped(sender: loginButton)
    }
}


extension ViewAccount {
    //MARK: настраиваем изображение аккаунта
    func setupImage(){
        image.image = UIImage(named: "UserImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
        image.makeRounded()
    }
    //MARK: настраиваем табличное отображение настроек
    func setupTable(){
        configure()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = UIScreen.main.bounds
        tableView.backgroundColor = .white
    }
    //MARK: настраиваем отображение Username
    func setupUserNameLabel(){
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.get("uid") as? String == user?.uid {
                        self.userNameTitle.text = "Hey, \(document.get("name") ?? " ")!"
                    }
                }
            }
        }
       // userNameTitle.text = "User"
        userNameTitle.textColor = UIColor.lightCornflowerBlue
        userNameTitle.textAlignment = .center
        userNameTitle.translatesAutoresizingMaskIntoConstraints = false
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
        emailVerificaionTitle.textColor = UIColor.lightCornflowerBlue
        emailVerificaionTitle.textAlignment = .center
        emailVerificaionTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: настраиваем надписть Account
    func setupNavigationTitle(){
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.blueGreen,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .regular)
        ]
        appearance.titleTextAttributes = attrs
        //standardAppearance = appearance
        //self.title = "Account"
    }
    //MARK: добавляем констрейты для вьюх
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        //add
        
        constraints.append(image.leadingAnchor.constraint(
            equalTo: leadingAnchor, constant: UIScreen.main.bounds.width/3))
        constraints.append(image.trailingAnchor.constraint(
            equalTo: trailingAnchor, constant: -UIScreen.main.bounds.width/3))
        constraints.append(image.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.width/3))
        constraints.append(image.topAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor))
 
        constraints.append(userNameTitle.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10))
        constraints.append(userNameTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(userNameTitle.trailingAnchor.constraint(equalTo: trailingAnchor))
        
        constraints.append(emailVerificaionTitle.topAnchor.constraint(equalTo: userNameTitle.bottomAnchor, constant: 10))
        constraints.append(emailVerificaionTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(emailVerificaionTitle.trailingAnchor.constraint(equalTo: trailingAnchor))
    
        constraints.append(tableView.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(
            equalTo:safeAreaLayoutGuide.trailingAnchor))
       constraints.append(tableView.bottomAnchor.constraint(
        equalTo: safeAreaLayoutGuide.bottomAnchor))
        constraints.append(tableView.topAnchor.constraint(
            equalTo: emailVerificaionTitle.bottomAnchor))
     
        //Activate
        NSLayoutConstraint.activate(constraints)
    }
    
    /* //MARK: позволяет активировать отображение заголовока секций таблицы
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    } */
    
    //MARK: количество секций таблицы
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    //MARK: количество строк в каждой секции в таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    //MARK: определяем вид строки таблицы, статическая или переключатель
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath
            ) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .staticCell(let model):
            model.handler()
            
        case .switchCell(let model):
            model.handler()
        }
    }
    //MARK: настраиваем наполнение каждой строки таблицы настроек
    func configure() {
        models.append(Section(title: "Screen", options: [
            .switchCell(model: SettingsSwitchOption(title: "Light/Dark mode", icon: UIImage(systemName: "airplane"), iconBackgroundColor: .systemRed, handler: {
                
            }, isOn: true))
        ]))
        models.append(Section(title: "General", options: [
            .staticCell(model: SettingsOption(title: "Geolocation", icon: UIImage(systemName: "map"), iconBackgroundColor: .systemPink) {
                print("tapped first cell")
            }),
            .staticCell(model: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell.badge"), iconBackgroundColor: .link) {
                
            }),
            .staticCell(model:SettingsOption(title: "Payment method", icon: UIImage(systemName: "creditcard"), iconBackgroundColor: .systemGreen) {
                
            })
        ]))
        models.append(Section(title: "Favorites", options: [
            .staticCell(model: SettingsOption(title: "favorites", icon: UIImage(systemName: "heart"), iconBackgroundColor: .systemRed) {
                
            })
        ]))
    }
    
//    @objc func showLoginController() {
//        let firebaseAutch = Auth.auth()
//        do{
//            try firebaseAutch.signOut()
//        } catch let _ as NSError {
//            print("не вышел из аакаунта")
//        }
////
////        let controller = LoginController()
////        navigationController?.pushViewController(controller, animated: true)
//    }
    
}

extension UIImageView {
    //MARK: Функция позволяет сделать круглое изображение
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
      }
}

