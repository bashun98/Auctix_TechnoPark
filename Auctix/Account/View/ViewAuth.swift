//
//  ViewAuth.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 05.11.2021.
//

import Firebase
import UIKit

protocol GoToLogin: AnyObject {
    func loginButtonTapped(sender: UIButton)
}

class ViewAuth: UIView{
        
    private let requestLabel = UILabel()
    private let questionLabel = UILabel()
    private let nextButton = UIButton(type: .system)
    
    weak var delegate: GoToLogin?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview(requestLabel)
        addSubview(questionLabel)
        addSubview(nextButton)
        setupElements()

    }
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayuot()
    }
    @objc
    func loginButtonTapped() {
        delegate?.loginButtonTapped(sender: nextButton)
    }
    
}

extension ViewAuth {
    func setupElements(){
        
        questionLabel.text = "Or maybe you want to register?"
        questionLabel.font = .systemFont(ofSize: 36)
        questionLabel.textColor = UIColor.blueGreen
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.textAlignment = .center
        questionLabel.lineBreakMode = .byCharWrapping
        questionLabel.numberOfLines = 0
        
        requestLabel.text = "Sign in to your account."
        requestLabel.font = .systemFont(ofSize: 36)
        requestLabel.textColor = UIColor.blueGreen
        requestLabel.translatesAutoresizingMaskIntoConstraints = false
        requestLabel.textAlignment = .center
          
        nextButton.backgroundColor = UIColor.honeyYellow
        nextButton.layer.cornerRadius = 25
        nextButton.setTitle("Log in", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        nextButton.isUserInteractionEnabled = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
}

extension ViewAuth {
    func setupLayuot(){
        NSLayoutConstraint.activate([
            requestLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height/4),
            requestLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            requestLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
            questionLabel.topAnchor.constraint(equalTo: requestLabel.bottomAnchor, constant: 25),
            questionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 35),
            questionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -35),
            
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 25),
            nextButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
