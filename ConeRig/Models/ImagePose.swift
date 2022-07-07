//
//  ImagePose.swift
//  ConeRig
//
//  Created by Mac on 07.07.2022.
//

import UIKit
import MLKitPoseDetection

typealias PoseInfo = PoseLandmark
extension PoseInfo {
    public func point() -> CGPoint {
        return CGPoint(x: position.x, y: position.y)
    }
}

public struct Pose {
    let leftWrist:PoseInfo
    let leftElbow:PoseInfo
    let leftShoulder:PoseInfo
    let leftHeel:PoseInfo
    let leftKnee:PoseInfo
    let leftHip:PoseInfo
    let rightWrist:PoseInfo
    let rightElbow:PoseInfo
    let rightShoulder:PoseInfo
    let rightHeel:PoseInfo
    let rightKnee:PoseInfo
    let rightHip:PoseInfo
}

typealias ImagePoses = [ImagePose]
public struct ImagePose {
    let image:UIImage
    let pose:Pose
}
