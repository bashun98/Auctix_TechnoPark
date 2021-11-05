//
//  OnboardingViewController.swift
//  Auctix
//
//  Created by Евгений Башун on 28.10.2021.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {

    private let label = UILabel()
    private let extralabel = UILabel()
    private let buttonContinue = UIButton()
    private let buttonSignUp = UIButton()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayout()
    }
    
    private func initialize() {
        view.backgroundColor = UIColor.blueGreen
        setupButtons()
        setupLabels()
    }
    
    struct Constants {
        static let leading: CGFloat = 50
        static let buttonHeight: CGFloat = 40
        static let buttonWidth: CGFloat = 150
        static let bottomOrTop: CGFloat = 70
    }
    
    private func setupButtons() {
        buttonContinue.setTitle("Register later", for: .normal)
        buttonContinue.titleLabel?.numberOfLines = 0
        buttonContinue.titleLabel?.font = UIFont(name: FontsName.regular.rawValue, size: 14)
        buttonContinue.addTarget(self, action: #selector(buttonContinueTapped), for: .touchUpInside)
        buttonSignUp.backgroundColor = UIColor.honeyYellow
        buttonSignUp.setTitle("Sign Up", for: .normal)
        buttonSignUp.titleLabel?.font = UIFont(name: FontsName.regular.rawValue, size: 20)
        buttonSignUp.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonSignUp.layer.cornerRadius = 20
        view.addSubview(buttonContinue)
        view.addSubview(buttonSignUp)
    }
    
    private func setupLabels() {
        label.text = "🎉 Welcome! 🎉"
        label.font = UIFont(name: FontsName.black.rawValue, size: 26)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        extralabel.text = "We are happy to welcome you! Using our application, you can buy rare paintings that are shown at exhibitions. Register in the app to bid on the paintings you like."
        extralabel.font = UIFont(name: FontsName.regular.rawValue, size: 24)
        extralabel.numberOfLines = 0
        extralabel.textColor = .white
        extralabel.adjustsFontSizeToFitWidth = true
        view.addSubview(label)
        view.addSubview(extralabel)
    }
    
    private func setupLayout() {
        buttonContinue.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/20)
            make.leading.trailing.equalToSuperview().inset(Constants.leading)
        }
        
        buttonSignUp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(buttonContinue).inset(Constants.bottomOrTop/2)
            make.height.equalTo(Constants.buttonHeight)
            make.width.equalTo(Constants.buttonWidth)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height/10)
        }
        
        extralabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.leading)
            make.top.equalTo(label).inset(Constants.bottomOrTop)
            make.bottom.lessThanOrEqualTo(buttonSignUp).inset(Constants.bottomOrTop)
        }
    }
    
    @objc private func buttonContinueTapped() {
        let tabBarVC = TabBarViewController()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.window?.rootViewController = tabBarVC
        UserDefaults.standard.set(true, forKey: "isFirstStart")
    }
}

