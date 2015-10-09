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

public class GalleryDataSource {
//  let assetsLibrary = ALAssetsLibrary()
  var photoAssets: PHFetchResult?
  var images: [UIImage] = [UIImage]()

  init() {
    authorizeForAccess { () -> Void in
      //success
      self.getAllImagesFromGallery()

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

        imageManager.requestImageForAsset(imageAsset, targetSize: imageSize, contentMode: PHImageContentMode.AspectFit, options: options, resultHandler: { (image, info) -> Void in
          self.images.append(image!)
        })
      }
    })
  }
}