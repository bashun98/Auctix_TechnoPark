//
//  AccountButtonTabViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 18.10.2021.
//

import UIKit
import Firebase

class AccountButtonTabViewController: UIViewController{
    //MARK: тестовая кнопка входа в аккаунт
//    private let loginButton: UIButton = {
//        let button = UIButton(type: .system)
//
//        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 33/255, green: 158/255, blue: 188/255, alpha: 1), .font: UIFont.boldSystemFont(ofSize: 16)]
//
//        let attriburedTitle = NSMutableAttributedString(string: "Log Out",
//                                                        attributes: atts)
//
//        button.setAttributedTitle(attriburedTitle, for: .normal)
//
//        button.addTarget(self, action: #selector(showLoginController), for: .touchUpInside)
//
//        return button
//    }()
//
//    private let tableView: UITableView = {
//        let table = UITableView(frame: .zero, style: .insetGrouped)
//        table.register(SettingTableViewCell.self,
//                       forCellReuseIdentifier: SettingTableViewCell.identifier)
//        table.translatesAutoresizingMaskIntoConstraints = false
//        table.alwaysBounceVertical = false
//
//        table.register(SwitchTableViewCell.self,
//                       forCellReuseIdentifier: SwitchTableViewCell.identifier)
//        return table
//    }()
//
//    var models = [Section]()
//    var image = UIImageView()
//    var userNameTitle = UILabel()
//    let label = UILabel()
//    let appearance = UINavigationBarAppearance()
    let viewAuth = ViewAuth()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAuth()
    }
    
    func setupAccView(){
        if let viewWithTag = self.view.viewWithTag(20) {
            viewWithTag.removeFromSuperview()
        }
        let viewAcc = ViewAccount()
        viewAcc.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAcc)
        viewAcc.tag = 20
        viewAcc.delegate = self
        NSLayoutConstraint.activate([
            viewAcc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewAcc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewAcc.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewAcc.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupAuthView(){
        if let viewWithTag = self.view.viewWithTag(10) {
                viewWithTag.removeFromSuperview()
        }
        viewAuth.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAuth)
        viewAuth.tag = 10
        viewAuth.delegate = self
        NSLayoutConstraint.activate([
            viewAuth.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewAuth.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewAuth.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewAuth.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension AccountButtonTabViewController: GoToLogin {
    func loginButtonTapped(sender: UIButton){
        navigationController?.pushViewController(LoginController(), animated: false)
    }
}

extension AccountButtonTabViewController: GoFuncAccount {
    func logoutButtonTapped(sender: UIButton){
        let firebaseAutch = Auth.auth()
        do{
            try firebaseAutch.signOut()
            viewWillAppear(false)
            //navigationController?.popToRootViewController(animated: false)
        } catch _ as NSError {
            print("не вышел из аакаунта")
        }
    }
}

extension AccountButtonTabViewController {

    func setupAuth() {
        let user = Auth.auth().currentUser
        if user == nil {
            setupAuthView()
        } else {
            setupAccView()
        }
    }
//
//    @objc func showLoginController() {
//        let firebaseAutch = Auth.auth()
//        do{
//            try firebaseAutch.signOut()
//            navigationController?.pushViewController(LoginController(), animated: false)
//        } catch let _ as NSError {
//            print("не вышел из аакаунта")
//        }
////
////        let controller = LoginController()
////        navigationController?.pushViewController(controller, animated: true)
//    }
//
}

//extension UIImageView {
//    //MARK: Функция позволяет сделать круглое изображение
//    func makeRounded() {
//        self.layer.borderWidth = 1
//        self.layer.masksToBounds = false
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.cornerRadius = self.bounds.width / 2
//        self.clipsToBounds = true
//        self.contentMode = .scaleAspectFill
//      }
//}
