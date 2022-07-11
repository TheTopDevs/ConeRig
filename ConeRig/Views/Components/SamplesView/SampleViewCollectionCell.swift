//
//  SampleViewCollectionCell.swift
//  ConeRig
//
//  Created by Mac on 10.07.2022.
//

import Foundation
import UIKit

let SampleViewCollectionCellIdentifier = "SampleViewCollectionCell"

class SampleViewCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    public var sampleViewModel:SampleViewModel? {didSet{
        imageView.image = sampleViewModel?.image
    }}
}
