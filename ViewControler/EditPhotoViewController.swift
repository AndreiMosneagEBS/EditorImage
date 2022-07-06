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
    @IBOutlet weak var contrastCount: UILabel!
    @IBOutlet weak var brightnessCount: UILabel!
    @IBOutlet weak var monochromeCount: UILabel!
    @IBOutlet weak var sepiaCount: UILabel!
    @IBOutlet weak var vignetteCount: UILabel!
    @IBOutlet var sliderCollection: [UISlider]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        imageEdit.image = SetImage.getImage(assets:lastAssetSelected)
    }
    
    private func popToBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupButton() {
        setButtonColor.tintColor = UIColor(named: "Color-1")
        shareButtonOutlet.tintColor = UIColor(named: "Color")
        bacButtonOutlet.tintColor = UIColor(named: "Color")
        viewOutlet.layer.cornerRadius = viewOutlet.frame.height / 2
        viewOutlet.backgroundColor = UIColor(named: "Color")
    }
    
    
        
    private func conditionSine(value: Float) -> String {
        var value = String(Int(value))
        if value.prefix(1) != "-", value != "0" {
            value = "+\(value)"
        }
        return value
    }
    
    // MARK: - Action
    
    @IBAction func backButton(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        SharedServices.sharedImage(image: SetImage.getImage(assets: lastAssetSelected), parentView: self)
    }
    
    
    @IBAction func contrastSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        contrastCount.text = value
//        increaseContrast(setAssetsImage(), value: Int(sender.value))
    
    }
    
    @IBAction func brightnessSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        brightnessCount.text = value
        }
    
    @IBAction func monochromeSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        monochromeCount.text = value
    }
    
    @IBAction func sepiaSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        sepiaCount.text = value
    }
    
    @IBAction func vignetteSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        vignetteCount.text = value
    }
    
}
