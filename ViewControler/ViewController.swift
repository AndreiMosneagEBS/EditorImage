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
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var viewEditConfirm: UIView!
    @IBOutlet weak var shareButtonSelect: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var delegate: ViewControllerDelegate?
    
    private var image: [PHAsset] = []
    private var lastAssetSelected: PHAsset?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
        populatePhotos()
        CollectionView.delegate = self
        updateEditButtons()
        editButton()
        
    }
    
    @objc func holdDown (sender: UIButton) {
        cancelButtonOutlet.backgroundColor = .systemBackground
    }
    
    @objc func holdRelease (sender: UIButton) {
        cancelButtonOutlet.backgroundColor = UIColor(red: 0 , green: 26, blue: 95, alpha: 1)
    }
    
    
    
    private func editButton() {
        shareButtonSelect.tintColor = UIColor(named: "Color")
        cancelButtonOutlet.layer.cornerRadius = 4
        cancelButtonOutlet.layer.borderWidth = 1
        cancelButtonOutlet.layer.borderColor = UIColor.gray.cgColor
        editButtonOutlet.layer.cornerRadius = 4
        cancelButtonOutlet.addTarget(self, action: #selector(holdDown), for: .touchUpInside)
        cancelButtonOutlet.addTarget(self, action: #selector(holdRelease), for: .touchDown)
        cancelButtonOutlet.backgroundColor = .systemBackground
    }
    
    private func registerCell() {
        CollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        CollectionView.delegate = self
        CollectionView.dataSource = self
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
                    self?.CollectionView.reloadData()
                }
            }
        }
    }
    
    private func updateEditButtons() {
        viewEditConfirm.isHidden = lastAssetSelected == nil
        shareButtonSelect.isHidden = lastAssetSelected == nil
    }
    
    
    //MARK: - Actions
    
    
    @IBAction func cancelButtonInside(_ sender: UIButton) {
        viewEditConfirm.isHidden = true
        shareButtonSelect.isHidden = true
        lastAssetSelected = nil
        CollectionView.reloadData()
       }
    
    

    
    @IBAction func editButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editViewController = storyBoard.instantiateViewController(withIdentifier: "EditPhotoViewController") as! EditPhotoViewController
        editViewController.lastAssetSelected = self.lastAssetSelected
        
        self.navigationController?.pushViewController(editViewController, animated: true)
        
    }
    
    @IBAction func shaderButton(_ sender: Any) {
        SharedServices.sharedImage(image: SetImage.getImage(assets: lastAssetSelected), parentView: self)
    }
}

//MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell
        else {
            fatalError("ImageCollectionViewCell Is not found")
        }
        
        let asset = self.image[indexPath.row]
        
        cell.loadAsset(imgAsset: asset, isSelected: asset == self.lastAssetSelected)
        
        cell.cellDelegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (CollectionView.bounds.width / 4) - 8, height: 100)
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
        CollectionView.reloadData()
    }
    }
//
