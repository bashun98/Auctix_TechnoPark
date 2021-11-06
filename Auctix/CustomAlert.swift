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

    func showAlert(title: String, message: String, viewController: UIViewController) {
        
        guard let targetView = viewController.view else { return }
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = Constrans.backgroundAlpha
        })

    }
    
    
}
