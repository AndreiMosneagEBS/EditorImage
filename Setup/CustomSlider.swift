//
//  CustomSlider.swift
//  ImageEditor
//
//  Created by Andrei Mosneag on 06.07.2022.
//

import Foundation
import UIKit
class CustomSlider: UISlider {

    override func awakeFromNib() {
       super.awakeFromNib()
//       self.setThumbImage(UIImage(named:"Night Vision Slider Knob3.png")!, for:.normal)

       let trackingImageleft  = UIImage(named:"trackMaximum")!
        let trackingImageRight = UIImage(named:"dividerMinimum")!

        self.setMinimumTrackImage(trackingImageleft, for:.normal)
//       self.setMaximumTrackImage(trackingImageRight, for:.normal)
    }
    override func layoutSubviews() {
        
        super.layoutSubviews()
        super.layer.cornerRadius = self.frame.height/2  //Do something additional if you want to do!.
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 2 //Size of your track
        return newBounds
    }
}
