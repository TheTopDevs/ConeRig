//
//  CGExtension.swift
//  ConeRig
//
//  Created by Mac on 07.07.2022.
//

import CoreGraphics

extension CGRect {
    func  minusHeight(_ height:CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.size.width, height: self.size.height - height)
    }
    
    func  rect(withHeight height:CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.size.width, height: height)
    }
}

extension CGPoint {
    static func - (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs - rhs.x, y: rhs.y)
    }
}
