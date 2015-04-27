//
//  RecipeIngredientsInterfaceController.swift
//  SousChef
//
//  Created by chenzhipeng on 4/27/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import WatchKit
import Foundation
import SousChefKit

class RecipeIngredientsInterfaceController: WKInterfaceController {
  @IBOutlet weak var table: WKInterfaceTable!
  
  var recipe: Recipe?
  
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
      
      recipe = context as? Recipe
      
      // 1 
      if let ingredients = recipe?.ingredients {
        // 2
        table.setNumberOfRows(ingredients.count, withRowType: "IngredientRow")
        
        for (index, ingredient) in enumerate(ingredients) {
          // 3
          let controller = table.rowControllerAtIndex(index) as! IngredientRowController
          // 4
          controller.nameLabel.setText(ingredient.name.capitalizedString)
          controller.measurementLabel.setText(ingredient.quantity)
        }
      }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
