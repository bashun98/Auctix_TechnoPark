//
//  ListButtonViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 19.10.2021.
//

import UIKit

class ListButtonTabViewController: UIViewController {

    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.selectedIndex = 2
        //self.title = "List"
        
        label.text = "List"
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
