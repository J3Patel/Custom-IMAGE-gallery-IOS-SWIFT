//
//  GalleryViewController.swift
//  photoPickerView
//
//  Created by Jatin on 09/10/15.
//  Copyright © 2015 jatin. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    let NUMBER_OF_CELLS_IN_ROW: CGFloat = 5
    let interSpacingBetweenItem: CGFloat = 5
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    var photosData: GalleryDataSource = GalleryDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.registerNib(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
}


extension GalleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
        cell.photoImageView.image = photosData.images[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosData.images.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = (galleryCollectionView.bounds.width - (NUMBER_OF_CELLS_IN_ROW  * interSpacingBetweenItem)) / NUMBER_OF_CELLS_IN_ROW
        return CGSize(width: size, height: size)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return interSpacingBetweenItem
    }
    
    func imageSelected(image: UIImage) {
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imageAssets = photosData.photoAssets?.objectAtIndex(indexPath.item)
        GalleryDataSource.getHighQualityImage(imageAssets!, getImage: imageSelected)
    }
    
}
