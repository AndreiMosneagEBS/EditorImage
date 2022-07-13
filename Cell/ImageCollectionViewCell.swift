//
//  ImageCollectionViewCell.swift
//  ImageEditor
//
//  Created by Andrei Mosneag on 04.07.2022.
//

import UIKit
import Photos

protocol ImageCollectionViewCellDelegate: AnyObject {
    func checkEdit(asset: PHAsset)
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "ImageCollectionViewCell"
    weak var cellDelegate: ImageCollectionViewCellDelegate?
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    func configView() {
        checkButton.image(for: .selected)
        imageViewCell.layer.cornerRadius = 4
    }
    private func imageConfig() {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
        imageConfig()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configView()
    }
    
    private var asset: PHAsset?
    
    func loadAsset(imgAsset: PHAsset, isSelected: Bool) {
        self.asset = imgAsset
        
        checkButton.isSelected = isSelected
        
        let manager = PHImageManager.default()
        manager.requestImage(for: imgAsset,
                             targetSize: CGSize(width: 100, height: 100),
                             contentMode: .aspectFit,
                             options: nil) { [weak self] image, _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if self.asset == imgAsset {
                    self.imageViewCell.image = image
                }
                
            }
        }
    }
    @IBAction func isSelectedButtonAction(_ sender: UIButton) {
        cellDelegate?.checkEdit(asset: self.asset!)
        
        }
}
    

