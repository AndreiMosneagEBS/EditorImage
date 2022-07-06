//
//  SetImage.swift
//  ImageEditor
//
//  Created by Andrei Mosneag on 06.07.2022.
//

import Foundation
import Photos
import UIKit

class SetImage {
    
    let shared = SetImage()
    
//    var lastAssetSelected: PHAsset?

    
   static func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 2000, height: 2000), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
        })
        return thumbnail
    }
    
   static func getImage(assets: PHAsset? ) -> UIImage {
        var photo = UIImage()
        if let image = assets {
            let image = getAssetThumbnail(asset: image)
            photo = image
        }
        return photo

    }
    
}
