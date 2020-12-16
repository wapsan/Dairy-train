//
//  ProgressDrawer.swift
//  Dairy Training
//
//  Created by cogniteq on 16.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import UIKit

struct ProgressDrawer {
    
    
    private static func getCircularPath(for view: UIView) -> UIBezierPath {
        let centerY = view.bounds.origin.x + view.bounds.width / 2
        let centerX = view.bounds.origin.y + view.bounds.height / 2
        let center = CGPoint(x: centerY, y: centerX)
        let radius = view.bounds.height / 2
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2.0,
                                        endAngle: 3 * CGFloat.pi / 2.0,
                                        clockwise: true)
        return circularPath
    }
    
    static func drawProgress(progressLayer: CAShapeLayer, defaultLayer: CAShapeLayer, for view: UIView, with value: Float) {
        
        defaultLayer.path = ProgressDrawer.getCircularPath(for: view).cgPath
        defaultLayer.strokeColor = DTColors.controllSelectedColor.cgColor
        defaultLayer.lineWidth = view.bounds.height / 15
        defaultLayer.fillColor = UIColor.clear.cgColor
        defaultLayer.strokeEnd = 1
        defaultLayer.lineCap = .round
        view.layer.addSublayer(defaultLayer)
        
        progressLayer.path = ProgressDrawer.getCircularPath(for: view).cgPath
        progressLayer.strokeColor = UIColor.green.cgColor
        progressLayer.lineWidth = view.bounds.height / 15
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
        view.layer.addSublayer(progressLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.duration = 1
        basicAnimation.fromValue = 0
        basicAnimation.speed = 1
        basicAnimation.toValue = CGFloat(value)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "uorSoBasic")
    }
    
    
}
