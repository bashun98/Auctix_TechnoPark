//
//  TabBarVC.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 18.10.2021.
//

import UIKit

class TabBarVC: UITabBar {

    private func addShape(){
        let shapeLauer = CAShapeLayer()
        shapeLauer.path = createPath()
        
        shapeLauer.cornerRadius = 10
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
        self.unselectedItemTintColor = UIColor.white
        
    }
    
    func createPath () -> CGPath {
        let height: CGFloat = 15
        let path = UIBezierPath()
        let centerWidch = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: self.frame.width, y: 0), controlPoint: CGPoint(x: centerWidch, y: height))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }

}
