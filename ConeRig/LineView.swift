//
//  LineView.swift
//  ALFAAICoach
//
//  Created by Zabrodin on 21.12.2021.
//  Copyright © 2021 ALFA AI Coach. All rights reserved.
//

import UIKit

class LineView:UIView {
    public var points:[CGPoint]?  {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var lineColor:UIColor = .red
    public var image:UIImage? {didSet{if let _ = window {setNeedsDisplay()}}}
    public var lineWidth:CGFloat = 5.0 {didSet{if let _ = window {setNeedsDisplay()}}}
    private var lineShapeLayer : CAShapeLayer = CAShapeLayer()
    override func draw(_ rect: CGRect) {
        lineShapeLayer.removeFromSuperlayer()

        guard var points = points else { return }
        
        let firstPoint = points.removeFirst()
        if points.isEmpty { return }
                
        if let image = image {
            image.draw(in: CGRect(x: 0, y: 0, width: min(image.size.width, self.bounds.size.width),
                                  height: min(image.size.height, self.bounds.size.height)))
        }

        let bezierPath = UIBezierPath()
        bezierPath.move(to: firstPoint)
        points.forEach({bezierPath.addLine(to: $0)})

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        self.layer.addSublayer(shapeLayer)
        lineShapeLayer = shapeLayer
    }
}
