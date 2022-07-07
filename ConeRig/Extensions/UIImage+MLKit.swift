//
//  UIImageExtension.swift
//  ConeRig
//
//  Created by Mac on 07.07.2022.
//

import UIKit
import MLKitPoseDetectionAccurate
import MLKitPoseDetectionCommon
import MLKitVision

extension VisionImage {
    func fetchPoses(withOptions options: CommonPoseDetectorOptions, complition: @escaping ([Pose]?)->()) {
        let poseDetector = PoseDetector.poseDetector(options: options)
        poseDetector.process(self) {[weak self] detectedPoses, error in
            guard let _ = self else { return }
            print(poseDetector)
            guard error == nil else { complition(nil); return }
            guard let detectedPoses = detectedPoses, !detectedPoses.isEmpty else { complition([]); return }

            var poses:[Pose] = []
            for pose in detectedPoses {
                poses.append(Pose(
                                       leftWrist: pose.landmark(ofType: .leftWrist),
                                       leftElbow: pose.landmark(ofType: .leftElbow),
                                       leftShoulder: pose.landmark(ofType: .leftShoulder),
                                       leftHeel: pose.landmark(ofType: .leftHeel),
                                       leftKnee: pose.landmark(ofType: .leftKnee),
                                       leftHip: pose.landmark(ofType: .leftHip),
                                       rightWrist: pose.landmark(ofType: .rightWrist),
                                       rightElbow: pose.landmark(ofType: .rightElbow),
                                       rightShoulder: pose.landmark(ofType: .rightShoulder),
                                       rightHeel: pose.landmark(ofType: .rightHeel),
                                       rightKnee: pose.landmark(ofType: .rightKnee),
                                       rightHip: pose.landmark(ofType: .rightHip)
                                      ))
            }
            
            complition(poses)
        }

    }
}

extension UIImage {
    func fetchPoses(complition: @escaping (ImagePoses?)->()) {
        let visionImage = VisionImage(image: self)
        visionImage.orientation = self.imageOrientation
        let options = AccuratePoseDetectorOptions()
        options.detectorMode = .singleImage
        visionImage.fetchPoses(withOptions: options) { poses in
            print(visionImage)
            let imagePoses = poses?.map({ImagePose(image: self, pose: $0)})
            complition(imagePoses)
        }
    }
}
