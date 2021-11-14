//
//  AccountButtonTabViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 18.10.2021.
//

import UIKit
import Firebase

class AccountButtonTabViewController: UIViewController{
    
    private var flag = false
    private let viewAuth = ViewAuth()
    private let viewAcc = ViewAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAuth()
    }
    
    func setupView() {
        defaultView()
        if flag {
            if let viewWithTag = self.view.viewWithTag(10) {
                viewWithTag.removeFromSuperview()
                view.addSubview(viewAcc)
                viewAcc.translatesAutoresizingMaskIntoConstraints = false
                viewAcc.tag = 20
                viewAcc.delegate = self
                setupLayoutAcc()
            }
        }
        if flag == false {
            if let viewWithTag = self.view.viewWithTag(20) {
                viewWithTag.removeFromSuperview()
                defaultView()
//            } else {
//                defaultView()
            }
        }
    }
    
    func defaultView() {
        if self.view.viewWithTag(10) == nil && self.view.viewWithTag(20) == nil {
            view.addSubview(viewAuth)
            viewAuth.translatesAutoresizingMaskIntoConstraints = false
            viewAuth.tag = 10
            viewAuth.delegate = self
            setupLayoutAutch()
        }
    }
    func setupLayoutAcc() {
        NSLayoutConstraint.activate([
            viewAcc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewAcc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewAcc.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewAcc.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupLayoutAutch() {
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
            flag = false
        } else {
            flag = true
        }
        setupView()
    }
}

