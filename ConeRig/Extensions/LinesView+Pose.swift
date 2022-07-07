//
//  LinesView+Pose.swift
//  ConeRig
//
//  Created by Mac on 07.07.2022.
//

import UIKit

extension LinesView {
    func showPoses(_ poses: [Pose]?) {
        var lines:[[CGPoint]] = []
        poses?.forEach { pose in
            lines.append([pose.leftWrist.point(),
                               pose.leftElbow.point(),
                               pose.leftShoulder.point(),
                               pose.rightShoulder.point(),
                               pose.rightElbow.point(),
                               pose.rightWrist.point()
                              ])
            lines.append([pose.leftHeel.point(),
                               pose.leftKnee.point(),
                               pose.leftHip.point(),
                               pose.rightHip.point(),
                               pose.rightKnee.point(),
                               pose.rightHeel.point()
                              ])
            lines.append([
                                CGPoint(x: (pose.leftShoulder.point().x + pose.rightShoulder.point().x) / 2.0,
                                        y: (pose.leftShoulder.point().y + pose.rightShoulder.point().y) / 2.0),
                                CGPoint(x: (pose.leftHip.point().x + pose.rightHip.point().x) / 2.0,
                                        y: (pose.leftHip.point().y + pose.rightHip.point().y) / 2.0)
                             ])
            
        }
        
        self.changeColorFrame = 70
        self.lines = lines
    }
}
