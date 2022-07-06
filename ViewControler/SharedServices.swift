//
//  SharedServices.swift
//  ImageEditor
//
//  Created by Andrei Mosneag on 06.07.2022.
//

import Foundation
import UIKit
class SharedServices {
    
    static func sharedImage(image: UIImage, parentView: UIViewController) {
        
                let imageToShare = [ image ]
                let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = parentView.view
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        parentView.present(activityViewController, animated: true, completion: nil)
    }
    
}
