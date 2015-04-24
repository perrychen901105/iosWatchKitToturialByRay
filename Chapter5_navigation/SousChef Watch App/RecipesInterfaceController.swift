//
//  RecipesInterfaceController.swift
//  SousChef
//
//  Created by chenzhipeng on 4/24/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import WatchKit

class RecipesInterfaceController: WKInterfaceController {
  // 1
  @IBOutlet weak var table: WKInterfaceTable!
  let recipes = ["Cheeseburger", "Pizza", "Salad"]
  
  // 2
  // that's called just before the WKInterfaceController object is displayed onscreen.
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    // 3
    table.setNumberOfRows(recipes.count, withRowType: "RecipeRowType")
    
    // 4
    for (index, recipe) in enumerate(recipes) {
      let controller = table.rowControllerAtIndex(index) as! RecipeRowController
      controller.textLabel.setText(recipe)
    }
  }
  
  override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
    return recipes[rowIndex];
  }
}
