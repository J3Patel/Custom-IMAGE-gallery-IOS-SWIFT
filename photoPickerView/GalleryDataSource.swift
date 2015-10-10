//
//  GalleryDataSource.swift
//  photoPickerView
//
//  Created by Jatin on 09/10/15.
//  Copyright © 2015 jatin. All rights reserved.
//

import Foundation
import Photos
import UIKit

protocol PhotoGalleryDelegate {
    func dataDidChange()
}

public class GalleryDataSource {
    //  let assetsLibrary = ALAssetsLibrary()
    var photoAssets: PHFetchResult?
    var images: [UIImage] = [UIImage]()
    var selectedAlbum = "All Photos"
    var albumsName = [String]()
    var albumsAssets = [PHFetchResult]()
    var delegate: PhotoGalleryDelegate!
    var albumCount = [Int]()
    var albumCoverImages = [UIImage]()
    
    init() {
        authorizeForAccess { () -> Void in
            //success
            self.getAllImagesFromGallery()
            self.getAlbums()
            
        }
    }
    
    func authorizeForAccess(allowed:() -> Void) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status == PHAuthorizationStatus.Authorized {
                    allowed()
                }
            })
        } else if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            allowed()
        }
    }
    
    func getAllImagesFromGallery() {
        photoAssets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        let imageManager = PHCachingImageManager()
        photoAssets?.enumerateObjectsUsingBlock({ (object, count, unsafePointer) -> Void in
            if object is PHAsset {
                let imageAsset = object as! PHAsset
                let imageSize = CGSize(width: imageAsset.pixelWidth, height: imageAsset.pixelHeight)
                let options = PHImageRequestOptions()
                options.deliveryMode = PHImageRequestOptionsDeliveryMode.FastFormat
                if imageAsset.mediaType == PHAssetMediaType.Image {
                    imageManager.requestImageForAsset(imageAsset, targetSize: imageSize, contentMode: PHImageContentMode.AspectFit, options: options, resultHandler: { (image, info) -> Void in
                        self.images.append(image!)
                        self.delegate.dataDidChange()
                    })
                    
                }
            }
        })
    }
    
    
    func getImagesFromPHFetchResult(fetchResult: PHFetchResult) {
        images.removeAll()
        let imageManager = PHCachingImageManager()
        fetchResult.enumerateObjectsUsingBlock({ (object, count, unsafePointer) -> Void in
            if object is PHAsset {
                let imageAsset: PHAsset = object as! PHAsset
                let imageSize = CGSize(width: imageAsset.pixelWidth, height: imageAsset.pixelHeight)
                let options = PHImageRequestOptions()
                options.deliveryMode = PHImageRequestOptionsDeliveryMode.FastFormat
                if imageAsset.mediaType == PHAssetMediaType.Image { // if check for to show only images
                    imageManager.requestImageForAsset(imageAsset, targetSize: imageSize, contentMode: PHImageContentMode.AspectFit, options: options, resultHandler: { (image, info) -> Void in
                        self.images.append(image!)
                        self.delegate.dataDidChange()
                    })
                    
                }
            }
        })
    }
    
    func getAlbums() -> [String] {
        
        
        var albums = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .Any, options: nil)
        
        albums.enumerateObjectsUsingBlock { (object, Indexable, error) -> Void in
            //
            let aa =  object as! PHAssetCollection
            let vv = PHAsset.fetchAssetsInAssetCollection(aa, options: nil)
            if let albumName = aa.localizedTitle where vv.count > 0 {
                var doesContainImages = false
                vv.enumerateObjectsUsingBlock({ (object, index, pointer) -> Void in
                    let asset: PHAsset = object as! PHAsset
                    if asset.mediaType == PHAssetMediaType.Image {
                        doesContainImages = true
                    }
                })
                if doesContainImages {
                    self.albumsName.append(albumName)
                    self.albumsAssets.append(vv)
                    self.albumCount.append(vv.count)
                    self.saveCoverImageForAlbums(vv.objectAtIndex(vv.count - 1))
                }
                
                
            }
        }
        
        albums = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: nil)
        albums.enumerateObjectsUsingBlock { (object, Indexable, error) -> Void in
            let aa =  object as! PHAssetCollection
            let vv = PHAsset.fetchAssetsInAssetCollection(aa, options: nil)
            if let albumName = aa.localizedTitle where vv.count > 0 {
                var doesContainImages = false
                vv.enumerateObjectsUsingBlock({ (object, index, pointer) -> Void in
                    let asset: PHAsset = object as! PHAsset
                    if asset.mediaType == PHAssetMediaType.Image {
                        doesContainImages = true
                    }
                })
                if doesContainImages {
                    self.albumsName.append(albumName)
                    self.albumsAssets.append(vv)
                    self.albumCount.append(vv.count)
                    self.saveCoverImageForAlbums(vv.objectAtIndex(vv.count - 1))
                }
            }
        }
        return albumsName
    }
    
    func saveCoverImageForAlbums(asset: AnyObject) {
        let imageManager = PHCachingImageManager()
        let imageAsset = asset as! PHAsset
        let imageSize = CGSize(width: imageAsset.pixelWidth, height: imageAsset.pixelHeight)
        let options = PHImageRequestOptions()
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.FastFormat
        if imageAsset.mediaType == PHAssetMediaType.Image {
            imageManager.requestImageForAsset(imageAsset, targetSize: imageSize, contentMode: PHImageContentMode.AspectFit, options: options, resultHandler: { (image, info) -> Void in
                self.albumCoverImages.append(image!)
                self.delegate.dataDidChange()
            })
            
        }
    }
    
    func updateImagesForAlbum(index: Int) {
        print(albumsAssets[index])
        getImagesFromPHFetchResult(albumsAssets[index])
    }
    
    class func getHighQualityImage(imageAssets: AnyObject, getImage:(image: UIImage) -> Void) {
        var assets = PHAsset()
        if let asset = imageAssets as? PHAsset {
            assets = asset
        } else {
            return
        }
        
        let imageSize = CGSize(width: imageAssets.pixelWidth, height: imageAssets.pixelHeight)
        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        PHCachingImageManager().requestImageForAsset(assets, targetSize: imageSize, contentMode: .AspectFit, options: options) { (image, info) -> Void in
            if let image = image {
                getImage(image: image)
            }
            
        }
        
        
    }
}