//
//  SamplesView.swift
//  ConeRig
//
//  Created by Mac on 10.07.2022.
//

import Foundation
import UIKit

struct SampleViewModel {
    enum SampleViewModelType {
    case custom
    case image
    }
    
    let type:SampleViewModelType
    let image:UIImage
    
    public init(type:SampleViewModelType, image:UIImage) {
        self.type = type
        self.image = image
    }
    
    public init?(named:String){
        guard let image = UIImage(named: named) else { return nil }
        self.image = image
        self.type = .image
    }
}

protocol SamplesViewDelegate:AnyObject {
    func sampleViewDidChangeSample(_ sender:SamplesView, sample:SampleViewModel)
    func sampleViewDidSelectCustomSample(_ sender:SamplesView)
}

class SamplesView:UIView {
    public weak var actionDelegate:SamplesViewDelegate?
    public var samples:[SampleViewModel] = {
        var samples:[SampleViewModel] = []
        if let image = UIImage(systemName: "plus") {
            let plus = SampleViewModel(type: .custom, image: image)
            samples.append(plus)
        }

        if let p1 = SampleViewModel(named:"p1") {
            samples.append(p1)
        }
        
        if let p1 = SampleViewModel(named:"p2") {
            samples.append(p1)
        }
        
        if let p1 = SampleViewModel(named:"p3") {
            samples.append(p1)
        }
        
        return samples
    }() {didSet{
        collectionView.reloadData()
    }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private var collectionView:UICollectionView!
    
    private func commonInit() {
        let layouts = UICollectionViewFlowLayout()
        layouts.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layouts)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(UINib(nibName: SampleViewCollectionCellIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: SampleViewCollectionCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.reloadData()
    }
}

extension SamplesView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sample = samples[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SampleViewCollectionCellIdentifier, for: indexPath) as! SampleViewCollectionCell
        cell.sampleViewModel = sample
        return cell
    }
}

extension SamplesView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sample = samples[indexPath.row]
        switch sample.type {
        case .custom:
            self.actionDelegate?.sampleViewDidSelectCustomSample(self)
        case .image:
            self.actionDelegate?.sampleViewDidChangeSample(self, sample: sample)
        }
    }
}

extension SamplesView:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sample = samples[indexPath.row]
        return CGSize(width: self.bounds.height * sample.image.size.width / sample.image.size.height, height: self.bounds.height)
    }
}
