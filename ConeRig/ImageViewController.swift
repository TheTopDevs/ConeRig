//
//  ViewController.swift
//  ConeRig
//
//  Created by Mac on 24.06.2022.
//

import UIKit
import SceneKit
import MLKitPoseDetectionAccurate
import MLKitVision

class ImageViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lineView: LinesView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var poseDetector:PoseDetector = {
        let options = AccuratePoseDetectorOptions()
        options.detectorMode = .singleImage
        return PoseDetector.poseDetector(options: options)
    }()
    
    let image = UIImage(named: "p1")!
    var imagePoses: ImagePoses? {didSet{
        if let pose = imagePoses?.first {
            lineView.changeColorFrame = 70
            lineView.lines = [[pose.leftWrist.point(),
                               pose.leftElbow.point(),
                               pose.leftShoulder.point(),
                               pose.rightShoulder.point(),
                               pose.rightElbow.point(),
                               pose.rightWrist.point()
                              ],
                              [pose.leftHeel.point(),
                               pose.leftKnee.point(),
                               pose.leftHip.point(),
                               pose.rightHip.point(),
                               pose.rightKnee.point(),
                               pose.rightHeel.point()
                              ],
                              [
                                CGPoint(x: (pose.leftShoulder.point().x + pose.rightShoulder.point().x) / 2.0,
                                        y: (pose.leftShoulder.point().y + pose.rightShoulder.point().y) / 2.0),
                                CGPoint(x: (pose.leftHip.point().x + pose.rightHip.point().x) / 2.0,
                                        y: (pose.leftHip.point().y + pose.rightHip.point().y) / 2.0)
                             ]
            ]
        }
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sceneRootNode = sceneView?.scene?.rootNode
        
        imageView.image = image
        spinner.startAnimating()
        image.fetchPoses { [weak self] imagePoses in
            guard let self = self else { return }
            self.imagePoses = imagePoses
            self.spinner.stopAnimating()
        }
        
//                if leftAnkleLandmark.inFrameLikelihood > 0.5 {
//                    let position = leftAnkleLandmark.position
//                }

        }
    }




typealias PoseInfo = PoseLandmark
extension PoseInfo {
    public func point() -> CGPoint {
        return CGPoint(x: position.x, y: position.y)
    }
}

typealias ImagePoses = [ImagePose]
public struct ImagePose {
    let image:UIImage
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

extension UIImage {
    func fetchPoses(complition: @escaping (ImagePoses?)->()) {
        let options = AccuratePoseDetectorOptions()
        options.detectorMode = .singleImage
        let poseDetector = PoseDetector.poseDetector(options: options)
        let visionImage = VisionImage(image: self)
        visionImage.orientation = self.imageOrientation
        
        poseDetector.process(visionImage) {[weak self] detectedPoses, error in
            guard let self = self else { return }
            guard nil != poseDetector else { complition(nil); return }
            guard error == nil else { complition(nil); return }
            guard let detectedPoses = detectedPoses, !detectedPoses.isEmpty else { complition(nil); return }

            var poses:ImagePoses = []
            for pose in detectedPoses {
                poses.append(ImagePose(image: self,
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
