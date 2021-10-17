//
//  ViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 11.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let logoLabel1 = UILabel()
    let logoLabel2 = UILabel()
    let nameLabel = UILabel()
    let searchBar = UISearchBar()
    //let exhibitions_table = UICollectionView()
    let navigatorBar = UITabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabel()
        setupSearchBar()
        setupCollectionView()
        setupTabBar()

        view.addSubview(logoLabel1)
        view.addSubview(logoLabel2)
        view.addSubview(nameLabel)
        view.addSubview(searchBar)
        //view.addSubview(exhibitions_table)
        view.addSubview(navigatorBar)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayuot()
        
    }
    
    func setupLabel(){
        
        logoLabel1.text = "A"
        logoLabel1.font = .systemFont(ofSize: 40)
        logoLabel1.textColor = UIColor.honeyYellow  
        logoLabel1.backgroundColor = .white
        logoLabel1.translatesAutoresizingMaskIntoConstraints = false
        
        logoLabel2.text = "UCTIX"
        logoLabel2.font = .systemFont(ofSize: 40)
        logoLabel2.textColor = UIColor.blueGreen
        logoLabel2.backgroundColor = .white
        logoLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Good day, Иван Петров!"
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.lightCornflowerBlue
        nameLabel.backgroundColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupSearchBar(){
        
        searchBar.placeholder = "Search..."
        searchBar.backgroundColor = .systemGray
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCollectionView(){
        //exhibitions_table.backgroundColor = .red
        //exhibitions_table.largeContentTitle = "New"
        //сюда делекатов
    }
    
    func setupTabBar(){
        navigatorBar.backgroundColor = .red
        navigatorBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupImgView(){
        

        
    }
    
    func setupLayuot(){
        NSLayoutConstraint.activate([
            
            logoLabel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            logoLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            logoLabel2.leadingAnchor.constraint(equalTo: logoLabel1.leadingAnchor, constant: 25),
            logoLabel2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25),
            nameLabel.bottomAnchor.constraint(equalTo: logoLabel1.bottomAnchor, constant: 30),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchBar.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 70),
            //exhibitions_table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            //exhibitions_table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25),
            //exhibitions_table.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30),
            //exhibitions_table.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 150),
            //exhibitions_table.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 10),
            //navigatorBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            navigatorBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            navigatorBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            navigatorBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            
           
            
//            contentLogoImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            contentLogoImg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
//            contentLogoImg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12),

            
            

        ])
    }
    
   
}

