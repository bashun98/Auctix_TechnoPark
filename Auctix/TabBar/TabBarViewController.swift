//
//  TabBarViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 18.10.2021.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController , UITabBarControllerDelegate {
    
    private let listVC = UINavigationController(rootViewController: ListViewController())
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let accVC = UINavigationController(rootViewController: AccountButtonTabViewController())
    private let bidVC = UINavigationController(rootViewController: BidViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstSetup()
        setupView()
        setupButton()
        setupTabBarLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func firstSetup(){
        viewControllers = [homeVC, listVC, bidVC, accVC]
        self.delegate = self
        self.selectedIndex = 0
    }
    
    
    func setupButton(){
        //активный цвет
        UITabBar.appearance().tintColor = .honeyYellow
        //пассивный цвет
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
    // настройка градиента(тени) для бара кнопок
    func setupTabBarLayer() {

        let tabGradientView = UIView(frame: self.tabBar.bounds)
        tabGradientView.backgroundColor = UIColor.white
        tabGradientView.translatesAutoresizingMaskIntoConstraints = false;

        self.tabBar.addSubview(tabGradientView)
        self.tabBar.sendSubviewToBack(tabGradientView)
        tabGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tabGradientView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabGradientView.layer.shadowRadius = 4.0
        tabGradientView.layer.shadowColor = UIColor.systemGray.cgColor
        tabGradientView.layer.shadowOpacity = 0.6
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        return sizeThatFits
    }
}
