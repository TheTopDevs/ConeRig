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
    
    let image = UIImage(named: "p3")!
    var imagePoses: ImagePoses? {didSet{
        lineView.showPoses(imagePoses?.map({$0.pose}))
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

