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
 
        viewControllers = [homeVC, listVC, bidVC, accVC]
       
        self.delegate = self
        self.selectedIndex = 0
        setupView()
        setupButton()

        
        
    }
    
    func setupButton(){
        
        UITabBar.appearance().tintColor = .honeyYellow//нужный цвет
        UITabBar.appearance().unselectedItemTintColor = .lightCornflowerBlue
        //домашняя кнопка
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "HomeTabBar"), tag: 0)
        
        //кнопка списка

        listVC.tabBarItem = UITabBarItem(title: "List", image: #imageLiteral(resourceName: "ListTabBar"), tag: 0)
        
        //кнопка торгов
        
        bidVC.tabBarItem = UITabBarItem(title: "Bid", image: #imageLiteral(resourceName: "BidTabBar"), tag: 0)

        //кнопка аккаунта
        
        accVC.tabBarItem = UITabBarItem(title: "Acc", image: #imageLiteral(resourceName: "AccTabBar"), tag: 0)
        
    }
    
    func setupView() {
        
        view.backgroundColor = .white
        
    }

}
