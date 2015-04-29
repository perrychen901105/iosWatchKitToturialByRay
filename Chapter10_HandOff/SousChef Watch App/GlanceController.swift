//
//  GlanceController.swift
//  SousChef
//
//  Created by chenzhipeng on 4/29/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import WatchKit
import SousChefKit

class GlanceController: WKInterfaceController {
  
    @IBOutlet weak var statusLabel: WKInterfaceLabel!
    @IBOutlet weak var upNextLabel: WKInterfaceLabel!
    @IBOutlet weak var onDeckLabel: WKInterfaceLabel!
  
  let groceryList = GroceryList().flattenedGroceries()
  
  override func willActivate() {
    super.willActivate()
    
    // 1
    let items = groceryList.filter {
      $0.item is Ingredient
      }.map {
      $0.item as! Ingredient
    }
    
    // 2
    let notPurchased = items.filter {
      return $0.purchased == false
    }
    
    // 3
    let purchasedCount = items.count - notPurchased.count
    statusLabel.setText("\(purchasedCount)/\(items.count)")
    
    // 4
    if notPurchased.count > 0 {
      upNextLabel.setText(notPurchased[0].name.capitalizedString)
    }
    if notPurchased.count > 1 {
      onDeckLabel.setText(notPurchased[1].name.capitalizedString)
    }
    
  }
  
}
