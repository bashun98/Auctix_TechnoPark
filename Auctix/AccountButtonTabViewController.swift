//
//  AccountButtonTabViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 18.10.2021.
//

import UIKit

class AccountButtonTabViewController: UIViewController {

    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.selectedIndex = 4
        //self.title = "Acc"
        label.text = "Acc"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayuot()
        
    }
    func setupLayuot(){
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        
        ])
    }


}
