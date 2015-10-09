//
//  GalleryViewController.swift
//  photoPickerView
//
//  Created by Jatin on 09/10/15.
//  Copyright © 2015 jatin. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

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
    return CGSize(width: 90, height: 90)
  }

  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    print(indexPath.item)
  }

}
