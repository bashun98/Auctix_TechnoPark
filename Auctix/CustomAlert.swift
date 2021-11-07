//
//  CustomAlert.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 06.11.2021.
//

import Foundation
import UIKit

class CustomAlert {
    
    struct Constrans {
        static let backgroundAlpha: CGFloat = 0.8
    }
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        return view
    }()

    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.image = UIImage(named: "AlertIcon")
        return imageView
    }()

    private var myTargetView: UIView?
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        
        guard let targetView = viewController.view else { return }
        
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        
        targetView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.width, height: 300)
        targetView.addSubview(alertView)
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height)
        alertView.addSubview(backgroundImage)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 80, width: alertView.frame.width-200, height: 80))
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = UIColor.blueGreen
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 30, y: 90, width: alertView.frame.width - 200, height: 180))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.lightCornflowerBlue
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.numberOfLines = 0
        alertView.addSubview(messageLabel)
        
        let buttonAlert = UIButton(frame: CGRect(x: 100, y: alertView.frame.height - 60, width: alertView.frame.width - 280, height: 40))
        buttonAlert.layer.cornerRadius = 20
        buttonAlert.backgroundColor = UIColor.honeyYellow
        buttonAlert.setTitle("Ok", for: .normal)
        buttonAlert.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        buttonAlert.addTarget(self, action: #selector(dismisAlert), for: .touchUpInside)
        alertView.addSubview(buttonAlert)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = Constrans.backgroundAlpha
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.3, animations: {
                    self.alertView.center = targetView.center
                })
            }
        })

    }
    
    @objc
    func dismisAlert() {
        
        guard let targetView = myTargetView else { return }

        
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.height, width: targetView.frame.width - 80, height: 300)
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundView.alpha = 0
                }, completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.backgroundImage.removeFromSuperview()
                    }
                })
            }
        })

    }
    
}
