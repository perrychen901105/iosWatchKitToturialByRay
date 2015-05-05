//
//  OnDeviceCacheHelper.swift
//  SousChef
//
//  Created by Jack Wu on 2014-12-11.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import WatchKit

public class OnDeviceCacheHelper {
  
  public func addImageToCache(image:UIImage, name:String) {
    // get a reference to the current device on which to call the caching methods
    let device = WKInterfaceDevice.currentDevice()
    // use a while loop to evict images from the cache until your new one fits in. If addCachedImage(_:name:) succeeds the first time, the method won't execute the contents of the loop.
    while (device.addCachedImage(image, name: name) == false) {
      // cache is full
      let removedImage = removeRandomImageFromCache()
      if !removedImage {
        // Try one last time
        device.removeAllCachedImages()
        device.addCachedImage(image, name: name)
        break
      }
    }
  }
  
  public func cacheContainsImageNamed(name:String) -> Bool {
    return contains(cachedImages.keys, name)
  }
  
  private func removeRandomImageFromCache() -> Bool {
    let cachedImageNames = cachedImages.keys
    if let randomImageName = cachedImageNames.first {
      WKInterfaceDevice.currentDevice().removeCachedImageWithName(randomImageName)
      return true
    }
    return false
  }
  
  private var cachedImages: [String : NSNumber] = {
    return WKInterfaceDevice.currentDevice().cachedImages as! [String : NSNumber]
  }()

}