//
//  StrokeAnimation.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 12.12.2021.
//

import UIKit

class StrokeAnimation: CABasicAnimation {
    
    // 1
    enum StrokeType {
        case start
        case end
    }
    
    // 2
    override init() {
        super.init()
    }
    
    // 3
    init(type: StrokeType,
         beginTime: Double = 0.0,
         fromValue: CGFloat,
         toValue: CGFloat,
         duration: Double) {
        
        super.init()
        
        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
