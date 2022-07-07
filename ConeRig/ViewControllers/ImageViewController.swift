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
        if let pose = imagePoses?.first?.pose {
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

