//
//  KitchenTimerNotificationController.swift
//  SousChef
//
//  Created by chenzhipeng on 4/29/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import WatchKit

// 1
class KitchenTimerNotificationController: WKUserNotificationInterfaceController {
  // 2
  @IBOutlet weak var titleLabel: WKInterfaceLabel!
  @IBOutlet weak var messageLabel: WKInterfaceLabel!
  
  // 3
  override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: (WKUserNotificationInterfaceType) -> Void) {
    if let userInfo = localNotification.userInfo {
      processNotificationWithUserInfo(userInfo, withCompletion: completionHandler)
    }
  }
  
  // 4
  override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: (WKUserNotificationInterfaceType) -> Void) {
    processNotificationWithUserInfo(remoteNotification, withCompletion: completionHandler)
  }
  
  // 1
  func processNotificationWithUserInfo(userInfo: [NSObject: AnyObject], withCompletion completionHandler:(WKUserNotificationInterfaceType) -> Void) {
    // 2
    messageLabel.setHidden(true)
    if let message = userInfo["message"] as? String {
      messageLabel.setHidden(false)
      messageLabel.setText(message)
    }
    
    // 3
    titleLabel.setHidden(true)
    if let title = userInfo["title"] as? String {
      titleLabel.setHidden(false)
      titleLabel.setText(title)
    }
    
    // 4
    completionHandler(.Custom)
  }
}
