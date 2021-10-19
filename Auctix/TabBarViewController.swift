//
//  TabBarViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 18.10.2021.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    
    private let listView = ListButtonTabViewController()
    private let homeView = HomeButtonTabViewController()
    private let accView = AccountButtonTabViewController()
    private let bidView = BidButtonTabViewController()
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    //let navigationBar = UITabBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([homeView, listView, bidView, accView], animated: true)
        view.backgroundColor = .white
        
        self.delegate = self
        self.selectedIndex = 5
       
        setupMiddleButton()

        
        
    }
    
    func setupMiddleButton(){
        //домашняя кнопка
        
        let homeButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 4) - 80, y: 0, width: 45, height: 45))
        homeButton.setBackgroundImage(UIImage(named: "HomeTabBar"), for: .normal)
        self.tabBar.addSubview(homeButton)
        homeButton.addTarget(self, action: #selector(homeButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
        
        //кнопка списка
        
        let listButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 4)+20, y: 0, width: 50, height: 50))
        listButton.setBackgroundImage(UIImage(named: "ListTabBar"), for: .normal)
        self.tabBar.addSubview(listButton)
        listButton.addTarget(self, action: #selector(listButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
        
        //кнопка торгов
        
        let bidButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 4) + 120, y: 0, width: 45, height: 45))
        bidButton.setBackgroundImage(UIImage(named: "BidTabBar"), for: .normal)
        self.tabBar.addSubview(bidButton)
        bidButton.addTarget(self, action: #selector(bidButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
        
        //кнопка аккаунта
        
        let accButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 4)+220, y: 0, width: 45, height: 45))
        accButton.setBackgroundImage(UIImage(named: "AccTabBar"), for: .normal)
//        accButton.titleLabel = UILabel()
        self.tabBar.addSubview(accButton)
        accButton.addTarget(self, action: #selector(accButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
        
    }
    
    
    @objc
    func homeButtonAction(sender: UIButton){
        self.selectedViewController = homeView
    }
    @objc
    func listButtonAction(sender: UIButton){
        self.selectedViewController = listView
    }
    @objc
    func bidButtonAction(sender: UIButton){
        self.selectedViewController = bidView
    }
    @objc
    func accButtonAction(sender: UIButton){
        self.selectedViewController = accView
    }
    

}
