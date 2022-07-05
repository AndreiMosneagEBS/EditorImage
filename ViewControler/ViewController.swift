//
//  ViewController.swift
//  ImageEditor
//
//  Created by Andrei Mosneag on 30.06.2022.
//

import UIKit
import Foundation
import Photos

protocol ViewControllerDelegate {
    func confirmEdit()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    @IBOutlet weak var viewEditConfirm: UIView!
    
    var delegate: ViewControllerDelegate?
    
    private var image: [PHAsset] = []
    private var lastAssetSelected: PHAsset?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
        populatePhotos()
        PhotoCollectionView.delegate = self
//        viewEditConfirm.isHidden = false
        // Do any additional setup after loading the view.u
        
        updateEditButtons()
        
        
    }
    
    private func registerCell() {
        PhotoCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        PhotoCollectionView.register(UINib(nibName: "EditImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditImageCollectionViewCell.identifier)
        PhotoCollectionView.delegate = self
        PhotoCollectionView.dataSource = self
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization {[weak self] status in
            if status ==  .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                 options: nil)
                assets.enumerateObjects { (object, _, _) in
                    self?.image.append(object)
                }
                self?.image.reverse()
                DispatchQueue.main.async {
                    self?.PhotoCollectionView.reloadData()
                }
            }
        }
    }
    
    private func updateEditButtons() {
        viewEditConfirm.isHidden = lastAssetSelected == nil
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = PhotoCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell
        else {
            fatalError("ImageCollectionViewCell Is not found")
        }
        
        let asset = self.image[indexPath.row]
        
        cell.loadAsset(imgAsset: asset, isSelected: asset == self.lastAssetSelected)
        
        cell.cellDelegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (PhotoCollectionView.bounds.width / 4) - 8, height: 100)
    }
    
}
extension ViewController: ImageCollectionViewCellDelegate {
    func checkEdit(asset: PHAsset) {
        
        if asset == self.lastAssetSelected {
            self.lastAssetSelected = nil
        } else {
            lastAssetSelected = asset
        }
        
        updateEditButtons()
        PhotoCollectionView.reloadData()
    }
    }

