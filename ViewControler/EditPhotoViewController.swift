//
//  EditPhotoViewController.swift
//  ImageEditor
//
//  Created by Andrei Mosneag on 05.07.2022.
//
import Photos
import Foundation
import UIKit
import CoreImage

class EditPhotoViewController: UIViewController {
    
    private var beginImage: CIImage!
    var lastAssetSelected: PHAsset?
    var valueContrast = Int()
    var valueBrightness = Int()
    var valueSepia = Int()
    var valueMonochrome = Int()
    var valueVignette = Int()
    var changeValue: Bool = true
    
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
    
    @IBOutlet weak var contrastIntensity: UISlider!
    
    @IBOutlet weak var brightnessIntensiti: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        imageEdit.image = SetImage.getImage(assets:lastAssetSelected)
        beginImage = CIImage(image: SetImage.getImage(assets:lastAssetSelected))
        outputImageSet()
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
    
    private func outputImageSet() {
        DispatchQueue.global().async {
            let outputImage = self.beginImage
                .applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey : self.valueContrast + 1])
                .applyingFilter("CIExposureAdjust", parameters: [kCIInputEVKey : (self.valueBrightness / 2) / 4])
                .applyingFilter("CIColorControls", parameters: [kCIInputContrastKey : (self.valueMonochrome + 1)])
                .applyingFilter("CISepiaTone", parameters: [kCIInputIntensityKey : self.valueSepia ])
                .applyingFilter("CIVignette", parameters: [kCIInputIntensityKey : self.valueVignette])
            
            
            if let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
                DispatchQueue.main.async {
                    self.imageEdit.image =  UIImage(cgImage: cgImage)
                }
            }
        }
    }
    
    private func setOriginalImage(sender: UISlider) {
    
    }
    
    // MARK: - Action
    
    @IBAction func leftAction(_ sender: Any) {
        
    }
    
    
    @IBAction func rightAction(_ sender: Any) {
    }
    
    
    @IBAction func showOriginal(_ sender: Any) {
        imageEdit.image = UIImage(ciImage: beginImage)
        contrastIntensity.value = 0
        valueContrast = 0
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        SharedServices.sharedImage(image: SetImage.getImage(assets: lastAssetSelected), parentView: self)
    }
    
    @IBAction func contrastSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        contrastCount.text = value
        valueContrast = Int(sender.value)
        outputImageSet()
        
    }
    
    @IBAction func brightnessSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        brightnessCount.text = value
        valueBrightness = Int(sender.value)
        
        outputImageSet()
    }
    
    @IBAction func monochromeSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        monochromeCount.text = value
        valueMonochrome = Int(sender.value)
        outputImageSet()
    }
    
    @IBAction func sepiaSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        sepiaCount.text = value
        valueSepia = Int(sender.value)
        outputImageSet()
    }
    
    @IBAction func vignetteSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        vignetteCount.text = value
        valueVignette = Int(sender.value)
        outputImageSet()
    }
    
}
