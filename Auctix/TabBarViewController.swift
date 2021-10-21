//
//  TabBarViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 18.10.2021.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    
    private let listVC = UINavigationController(rootViewController: ListButtonTabViewController())
    private let homeVC = UINavigationController(rootViewController: HomeButtonTabViewController())
    private let accVC = UINavigationController(rootViewController: AccountButtonTabViewController())
    private let bidVC = UINavigationController(rootViewController: BidButtonTabViewController())
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    //let navigationBar = UITabBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        
        //self.tabBar.bounds.size.height = 300
        self.setViewControllers([homeVC, listVC, bidVC, accVC], animated: true)
       
        self.delegate = self
        self.selectedIndex = 0
       
        setupMiddleButton()

        
        
    }
    
    func setupMiddleButton(){
        //домашняя кнопка
        
        homeVC.title = "Home"
        homeVC.tabBarItem.image = UIImage(named: "HomeTabBar")
        
        
        //кнопка списка

        listVC.title = "List"
        listVC.tabBarItem.image = UIImage(named: "ListTabBar")
        
        //кнопка торгов

        bidVC.title = "Bid"
        bidVC.tabBarItem.image = UIImage(named: "BidTabBar")

        //кнопка аккаунта
        
        accVC.title = "Acc"
        accVC.tabBarItem.image = UIImage(named: "AccTabBar")
        
    }
    
//    
//    @objc
//    func homeButtonAction(sender: UIButton){
//        self.selectedViewController = homeVC
//    }
//    @objc
//    func listButtonAction(sender: UIButton){
//        self.selectedViewController = listVC
//    }
//    @objc
//    func bidButtonAction(sender: UIButton){
//        self.selectedViewController = bidVC
//    }
//    @objc
//    func accButtonAction(sender: UIButton){
//        self.selectedViewController = accVC
//    }
//    

}
