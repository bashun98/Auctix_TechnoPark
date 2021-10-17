//
//  LoadingScreenViewController.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 16.10.2021.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    let logoLabel = UILabel()
    let logoImg = UIImage(named: "Image2")
    let contentLogoImg = UIImageView()
    let contentMod = UIView.ContentMode(rawValue: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabel()
        setupImgView()
        view.addSubview(contentLogoImg)
        view.addSubview(logoLabel)
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayuot()
        
    }
    
    func setupLabel(){
        logoLabel.text = "Auctix"
        logoLabel.font = .systemFont(ofSize: 72)
        logoLabel.textColor = UIColor(red: 0.04, green: 0.911, blue: 0.967, alpha: 1)
        logoLabel.backgroundColor = .white
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupImgView(){
        
        //contentLogoImg.image = logoImg
        
        contentLogoImg.image = logoImg
        contentLogoImg.contentMode = .center
        contentLogoImg.contentMode = .scaleAspectFit//уменьшится под область(возможно)
       // contentLogoImg.contentMode = .scaleAspectFill//влезит в экран
     
        contentLogoImg.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func setupLayuot(){
        NSLayoutConstraint.activate([
            
            contentLogoImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentLogoImg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            contentLogoImg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12),

            
            logoLabel.bottomAnchor.constraint(equalTo: contentLogoImg.bottomAnchor, constant: 20),
            logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100)

        ])
    }
}
