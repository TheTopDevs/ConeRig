//
//  LinesView.swift
//  ALFAAICoach
//
//  Created by Zabrodin on 20.01.2022.
//  Copyright © 2022 ALFA AI Coach. All rights reserved.
//

import UIKit

class LinesView: UIView {
    public var lines:[[CGPoint]]?  {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var changeColorFrame = -1
    
    var lineColor:UIColor = .red
    var secondColor:UIColor = .yellow

    private var lineShapeLayers : [CAShapeLayer] = []
    override func draw(_ rect: CGRect) {
        
        lineShapeLayers.forEach({$0.removeFromSuperlayer()})
      
        lines?.forEach({ line in
            var points = line
            if points.isEmpty { return }
            let firstPoint = points.removeFirst()
                    
            let firstBezierPath = UIBezierPath()
            firstBezierPath.move(to: firstPoint)
            let secondBezierPath = UIBezierPath()
            var index = 0
            points.forEach({
                if index <= changeColorFrame {
                    firstBezierPath.addLine(to: $0)
                }
                
                if index == changeColorFrame - 1 {
                    secondBezierPath.move(to: $0)
                }
                
                if index > changeColorFrame - 1 {
                    secondBezierPath.addLine(to: $0)
                }
                index = index + 1
            })
           
            let firstShapeLayer = CAShapeLayer()
            firstShapeLayer.path = firstBezierPath.cgPath
            firstShapeLayer.strokeColor =  lineColor.cgColor
            firstShapeLayer.fillColor = UIColor.clear.cgColor
            firstShapeLayer.shadowColor =  lineColor.cgColor
            firstShapeLayer.shadowRadius = 10
            firstShapeLayer.shadowOpacity = 1
            firstShapeLayer.lineWidth = CGFloat(5.0)
            self.layer.addSublayer(firstShapeLayer)
            lineShapeLayers.append(firstShapeLayer)
            
            let secondShapeLayer = CAShapeLayer()
            secondShapeLayer.path = secondBezierPath.cgPath
            secondShapeLayer.strokeColor =  secondColor.cgColor
            secondShapeLayer.fillColor = UIColor.clear.cgColor
            secondShapeLayer.shadowColor =  secondColor.cgColor
            secondShapeLayer.shadowRadius = 10
            secondShapeLayer.shadowOpacity = 1
            secondShapeLayer.lineWidth = CGFloat(5.0)
            self.layer.addSublayer(secondShapeLayer)
            lineShapeLayers.append(secondShapeLayer)
        })
    }
}
