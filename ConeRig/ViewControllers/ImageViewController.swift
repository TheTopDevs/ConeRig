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
import Photos
import PhotosUI

class ImageViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lineView: LinesView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var samplesView: SamplesView!
    
    private var pickerController: PHPickerViewController?
    
    var poseDetector:PoseDetector = {
        let options = AccuratePoseDetectorOptions()
        options.detectorMode = .singleImage
        return PoseDetector.poseDetector(options: options)
    }()
    
    var image:UIImage? {didSet{
        guard image != imageView.image else { return }
        
        imageView.image = image
        self.imagePoses = nil
        
        if let image = image {
            spinner.startAnimating()
            image.fetchPoses { [weak self] imagePoses in
                guard let self = self else { return }
                self.imagePoses = imagePoses
                self.spinner.stopAnimating()
            }
        }
    }}
    
    var imagePoses: ImagePoses? {didSet{
        lineView.showPoses(imagePoses?.map({$0.pose}))
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image = UIImage(named: "p3")
        samplesView.actionDelegate = self
        
        
//                if leftAnkleLandmark.inFrameLikelihood > 0.5 {
//                    let position = leftAnkleLandmark.position
//                }

    }
    
    @IBAction func onEditTap(_ sender: Any) {
        samplesView.isHidden = !samplesView.isHidden
    }
}

extension ImageViewController:SamplesViewDelegate {
    func sampleViewDidChangeSample(_ sender: SamplesView, sample: SampleViewModel) {
        image = sample.image
    }
    
    func sampleViewDidSelectCustomSample(_ sender: SamplesView) {
        guard nil == pickerController else { return }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true)
        self.pickerController = pickerController
    }
}

extension ImageViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let _ = pickerController else { return }
        
        if let item = results.first?.itemProvider, item.canLoadObject(ofClass: UIImage.self) {
            item.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.image = image
                    }
                }
            }
        }
        
        self.pickerController = nil
        self.dismiss(animated: true)
    }
}
