//
//  GroceryInterfaceController.swift
//  SousChef
//
//  Created by chenzhipeng on 4/27/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import WatchKit
import Foundation
import SousChefKit

class GroceryInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
  
  let groceryList = GroceryList(useSample: true)
  
  lazy var flatList: [FlatGroceryItem] = {
    return self.groceryList.flattenedGroceries()
  }()
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
      
      updateTable()
        // Configure interface objects here.
    }

  func updateTable() {
    println("the flat list is \(flatList)")
    table.setRowTypes(flatList.map({ $0.id }))
    println("the mapped array is \(flatList.map({ $0.id }))")
    for i in 0..<table.numberOfRows {
      // 1
      let controller: AnyObject! = table.rowControllerAtIndex(i)
      let context = flatList[i]
      
      // 2
      if let row = controller as? GroceryTypeRowController {
        let type = context.item as! String
        row.textLabel.setText(type)
        row.IMAGE.setImageNamed(type.lowercaseString)
        // 3
      } else if let row = controller as? GroceryRowController {
        let item = context.item as! Ingredient
//        row.textLabel.setText(item.name.capitalizedString)
        if item.purchased {
          // 1
          let attributes = strikethroughCellTextAttributes
          let attributedText = NSAttributedString(string: item.name.capitalizedString, attributes: attributes)
          row.textLabel.setAttributedText(attributedText)
        } else {
          row.textLabel.setText(item.name.capitalizedString)
        }
        row.measurementLabel.setText(item.quantity)
        
        // 4
        let quantity = groceryList.quantityForItem(item)
        let quantityText = quantity > 1 ? "x\(quantity)" : ""
        row.quantityLabel.setText(quantityText)
      }
    }
  }
  
  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    // 1
    if let row = table.rowControllerAtIndex(rowIndex) as? GroceryRowController {
      let item = flatList[rowIndex].item as! Ingredient
      let text = item.name.capitalizedString
      
      // 2
      var attributes: [NSObject: AnyObject]?
      
      if item.purchased {
        attributes = cellTextAttributes
      } else {
        attributes = strikethroughCellTextAttributes
      }
      
      // 2
      groceryList.setIngredient(item, purchased: !item.purchased)
      groceryList.sync()
      
      // 3
      let attributedText = NSAttributedString(string: text, attributes: attributes)
      row.textLabel.setAttributedText(attributedText)
      
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

  var cellTextAttributes: [NSObject: AnyObject] {
    return [NSFontAttributeName: UIFont.systemFontOfSize(16),
      NSForegroundColorAttributeName: UIColor.whiteColor(),
        ]
  }
  
  var strikethroughCellTextAttributes: [NSObject: AnyObject] {
    return [NSFontAttributeName: UIFont.systemFontOfSize(16),
      NSForegroundColorAttributeName: UIColor.lightGrayColor(),
      NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
  }
  
}
