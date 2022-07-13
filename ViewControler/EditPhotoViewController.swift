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
    
    private enum SliderType: Int {
        case contrast = 1
        case brightness
        case monochrome
        case sepia
        case vignette
        
    }
    
    private class ModifiedValue {
        let type: SliderType
        let value: Int
        
        init(type: SliderType, value: Int) {
            self.type = type
            self.value = value
        }
        
        var backType: Int = 2 // 1 - left, 2 - right
    }
    
    private var modifiedSliderValues: [ModifiedValue] = []
    
    
    private var beginImage: CIImage!
    var lastAssetSelected: PHAsset?
    var valueContrast: Int = 0
    var valueBrightness = Int()
    var valueSepia = Int()
    var valueMonochrome = Int()
    var valueVignette = Int()
    var changeValue: Bool = true
    var valueOfSlider:[ (slider: UISlider, value: Int) ] = []
    var lastItem: Int = 0
    
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
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var contrastIntensity: UISlider!
    @IBOutlet weak var brightnessIntensity: UISlider!
    @IBOutlet weak var monochromeIntensity: UISlider!
    @IBOutlet weak var sepiaIntensity: UISlider!
    @IBOutlet weak var vignetteIntensity: UISlider!
    
    
    
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
        backButton.tintColor = UIColor(named:"Color")
        rightButton.tintColor = UIColor(named:"Color")

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
    
    private func backImage(sender:[ (slider: UISlider, value: Int) ], leftAction: UIButton, rightButton: UIButton) {
    
        
        
    }
    
    // MARK: - Action
    
    @IBAction func leftAction(_ sender: Any) {
        let _array = modifiedSliderValues.filter({ $0.backType == 2 })
    print(_array)
        let lastModifiedSlider = _array.dropLast().last
        print(lastModifiedSlider)
        lastModifiedSlider?.backType = 1
        
        print("type: \(lastModifiedSlider?.type) - v: \(lastModifiedSlider?.value)")
        
        if lastModifiedSlider?.type != .contrast {
            return
        }
        
        guard let value = lastModifiedSlider?.value else {
            return
        }
        
        let sliderClass = sliderCollection.first(where: { $0.tag == lastModifiedSlider?.type.rawValue })
        sliderClass?.value = Float(value)
        
        valueContrast = value
        contrastCount.text = "\(value)"
        outputImageSet()
        
        
//        var sliders = valueOfSlider.compactMap({$0.slider})
//        let index = sliders.lastIndex(where: {$0 == valueOfSlider.last?.slider })
//        guard let index = index else {
//            return
//        }
//
//        if lastItem == sliders.count {
//            backButton.isEnabled = false
//        }
//
//        switch sliders[index - lastItem] {
//        case contrastIntensity:
//            lastItem += 1
//            let value = valueOfSlider.compactMap({$0.value})
//            valueContrast = ((value.last ?? 0)) - lastItem
//            contrastCount.text = "\(Int(Float(valueOfSlider.last!.value)))"
//            outputImageSet()
////            valueOfSlider.removeLast()
////            print(valueOfSlider)
//
//
//        case brightnessIntensity:
//            lastItem += 1
//            valueBrightness = valueOfSlider.last!.value
//            brightnessCount.text = "\(Int(Float(valueOfSlider.last!.value)))"
//            outputImageSet()
//            print(valueOfSlider)
//
//
//        case monochromeIntensity:
//            lastItem += 1
//            monochromeIntensity.value = Float(valueOfSlider.last!.value)
//            monochromeCount.text = "\(Int(Float(valueOfSlider.last!.value)))"
//            print(valueOfSlider)
//
//        case sepiaIntensity:
//            lastItem += 1
//            sepiaIntensity.value = Float(valueOfSlider.last!.value)
//            sepiaCount.text = "\(Int(Float(valueOfSlider.last!.value)))"
//            print(valueOfSlider)
//
//        case vignetteIntensity:
//            lastItem += 1
//            vignetteIntensity.value = Float(valueOfSlider.last!.value)
//            vignetteCount.text = "\(Int(Float(valueOfSlider.last!.value)))"
//            print(valueOfSlider)
//
//        default:
//            break
//        }
//
//
        
    }
    
    
    @IBAction func rightAction(_ sender: Any) {
        let _array = modifiedSliderValues.filter({ $0.backType == 1 })
        let lastModifiedSlider = _array.dropFirst().first
        lastModifiedSlider?.backType = 2
        
        print("type: \(lastModifiedSlider?.type) - v: \(lastModifiedSlider?.value)")
        
        if lastModifiedSlider?.type != .contrast {
            
            return
        }
        
        guard let value = lastModifiedSlider?.value else {
            
            return
        }
        
        let sliderClass = sliderCollection.first(where: { $0.tag == lastModifiedSlider?.type.rawValue })
        sliderClass?.value = Float(value)
        
        valueContrast = value
        contrastCount.text = "\(value)"
        outputImageSet()
    }
    
    
    @IBAction func showOriginal(_ sender: Any) {
        imageEdit.image = UIImage(ciImage: beginImage)
        contrastIntensity.value = 0
        contrastCount.text = "0"
        brightnessIntensity.value = 0
        brightnessCount.text = "0"
        monochromeIntensity.value = 0
        monochromeCount.text = "0"
        sepiaIntensity.value = 0
        sepiaCount.text = "0"
        vignetteIntensity.value = 0
        vignetteCount.text = "0"
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        popToBack()
        
        
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        guard let imageEdit = imageEdit.image else {return}
        SharedServices.sharedImage(image: imageEdit, parentView: self)
        
    }
    
    
    @IBAction func saveButton(_sender: UIButton) {
        guard let image = imageEdit.image else {return}
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save error",
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!",
                                       message: "Your altered image has been saved to your photos. ",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func contrastSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        contrastCount.text = value
        valueContrast = Int(sender.value)
        outputImageSet()
    }
    
    @IBAction func contrastSliderEndChange(_ sender: UISlider) {
        guard let type = SliderType(rawValue: sender.tag) else {
            return
        }
        
        modifiedSliderValues.append(.init(type: type, value: Int(sender.value)))
//
//
//        valueOfSlider.first?.slider
//
//        switch sender {
//        case contrastIntensity:
//            valueOfSlider.append((contrastIntensity, Int(sender.value)))
//        case brightnessIntensity:
//            valueOfSlider.append((brightnessIntensity, Int(sender.value)))
//        case monochromeIntensity:
//            valueOfSlider.append((monochromeIntensity, Int(sender.value)))
//        case sepiaIntensity:
//            valueOfSlider.append((sepiaIntensity, Int(sender.value)))
//        case vignetteIntensity:
//            valueOfSlider.append((vignetteIntensity, Int(sender.value)))
//        default:
//            break
//        }
        backButton.isEnabled = true

        print(valueOfSlider)
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

extension Array {
  func last() -> Element? {
      if self.count < 2 {
          return nil
      }
      let index = self.count - 2
      return self[index]
  }
}
