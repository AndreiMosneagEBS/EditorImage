//
//  EditPhotoViewController.swift
//  ImageEditor
//
//  Created by Andrei Mosneag on 05.07.2022.
//
import Photos
import Foundation
import UIKit

class EditPhotoViewController: UIViewController {
    var lastAssetSelected: PHAsset?
    
    @IBOutlet weak var imageEdit: UIImageView!
    @IBOutlet weak var setButtonColor: UIButton!
    @IBOutlet weak var viewOutlet: UIView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var bacButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        setupButton()
    }
    
    private func setImage() {
        if let image = lastAssetSelected {
            let image = getAssetThumbnail(asset: image)
            imageEdit.image = image
        }
    }
    
    private func popToBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupButton() {
        setButtonColor.tintColor = UIColor(named: "Color-1")
        shareButtonOutlet.tintColor = .black
        bacButtonOutlet.tintColor = .black
        viewOutlet.layer.cornerRadius = viewOutlet.frame.height / 2
        viewOutlet.backgroundColor = UIColor(named: "Color")
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 2000, height: 2000), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
        })
        return thumbnail
    }
    @IBAction func backButton(_ sender: Any) {
        popToBack()
    }
    
}
