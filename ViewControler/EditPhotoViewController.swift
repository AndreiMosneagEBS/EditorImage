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
    
    var lastAssetSelected: PHAsset?
    var setFilter = ""
    
    var context = CIContext()
    var contrastFilter: CIFilter!
    var brightFilter: CIFilter!
    var monochromeFilter: CIFilter!
    var sepiaFilter: CIFilter!
    var vignetteFilter: CIFilter!
    
    private var typeFilter: TypeFilter = .contrast
    private var beginImage: CIImage?
    
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
        //        imagePickerControl(filter: typeFilter)
        beginImage = CIImage(image: SetImage.getImage(assets: lastAssetSelected))
    }
    
    enum TypeFilter: Int {
        case contrast
        case brightness
        case monochrome
        case sepia
        case vignette
    }
    
    private func imagePickerControl(filter: TypeFilter) {
        var setFilter = ""
        
        switch filter {
        case .contrast:
            setFilter = "CISepiaTone"
            contrastFilter = CIFilter(name: setFilter)
            contrastFilter.setValue(CIImage(image: SetImage.getImage(assets: lastAssetSelected)), forKey: kCIInputImageKey)
            applyProcessing()
            
        case .brightness:
            setFilter = "CIBloom"
            brightFilter =  CIFilter(name: setFilter)
            brightFilter.setValue(beginImage, forKey: kCIInputImageKey)
            brightessFilterApply()
            
        case .monochrome:
            setFilter = "CIColorMonochrome"
        case .sepia:
            setFilter = "CIVignette"
        case .vignette:
            setFilter = "CIVignette"
        }
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
    
    func applyProcessing() {
        contrastFilter.setValue(contrastIntensity.value, forKey: kCIInputIntensityKey)
        if let cgImage = context.createCGImage(contrastFilter.outputImage!, from: contrastFilter.outputImage!.extent) {
            beginImage = CIImage(cgImage: cgImage)
            imageEdit.image =  UIImage(cgImage: cgImage)
        }
    }
    
    func brightessFilterApply() {
        brightFilter.setValue(brightnessIntensiti.value, forKey: kCIInputIntensityKey)
        if let cgImage = context.createCGImage(brightFilter.outputImage!, from: brightFilter.outputImage!.extent) {
            beginImage = CIImage(cgImage: cgImage)
            imageEdit.image = UIImage(cgImage: cgImage)
        }
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
        imagePickerControl(filter: .contrast)
    }
    
    @IBAction func brightnessSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        brightnessCount.text = value
        imagePickerControl(filter: .brightness)
    }
    
    @IBAction func monochromeSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        monochromeCount.text = value
        imagePickerControl(filter: .monochrome)
    }
    
    @IBAction func sepiaSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        sepiaCount.text = value
        typeFilter = .sepia
    }
    
    @IBAction func vignetteSlider(_ sender: UISlider) {
        let value = conditionSine(value: sender.value)
        vignetteCount.text = value
        typeFilter = .vignette
    }
    
}
