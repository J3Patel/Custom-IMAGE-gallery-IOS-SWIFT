//
//  GalleryViewController.swift
//  photoPickerView
//
//  Created by Jatin on 09/10/15.
//  Copyright © 2015 jatin. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, PhotoGalleryDelegate {
    let NUMBER_OF_CELLS_IN_ROW: CGFloat = 5
    let interSpacingBetweenItem: CGFloat = 1
    
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumsTableView: UITableView!
    var photosData: GalleryDataSource = GalleryDataSource()
    var collectionViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosData.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionViewHeight = UIScreen.mainScreen().bounds.height - 64
//        collectionViewBottomConstraint.constant = collectionViewHeight
//        collectionViewTopConstraint.constant = -collectionViewHeight
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.registerNib(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        albumsTableView.registerNib(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "albumCell")
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        albumsTableView.reloadData()
        albumsTableView.tableFooterView = UIView()
        
    }
    
    @IBAction func closeGallery(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func openAlbums(sender: AnyObject) {
        if collectionViewTopConstraint.constant ==  0 {
            collectionViewTopConstraint.constant = collectionViewHeight
            collectionViewBottomConstraint.constant = -collectionViewHeight
            UIView.animateWithDuration(0.3) { () -> Void in
                self.view.layoutIfNeeded()
            }
        } else {
            collectionViewTopConstraint.constant = 0
            collectionViewBottomConstraint.constant = 0
            UIView.animateWithDuration(0.3) { () -> Void in
                self.view.layoutIfNeeded()
            }
        }
        
    }

}

extension GalleryViewController {
    func dataDidChange() {
        galleryCollectionView.reloadData()
    }
}

// MARK: TableView delegate
extension GalleryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = albumsTableView.dequeueReusableCellWithIdentifier("albumCell") as! AlbumTableViewCell
        cell.albumNameLabel.text = photosData.albumsName[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AlbumTableViewCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosData.albumsName.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        photosData.updateImagesForAlbum(indexPath.row)
        openAlbums(UIButton())
        titleHeader.text = photosData.albumsName[indexPath.row]
    }
}


// MARK: CollectionView delegate
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
