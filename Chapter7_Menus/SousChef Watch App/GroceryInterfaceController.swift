

import Foundation
import WatchKit
import SousChefKit

class GroceryInterfaceController: WKInterfaceController {

  @IBOutlet weak var table: WKInterfaceTable!

  let groceryList = GroceryList()

  lazy var flatList: [FlatGroceryItem] = {
    return self.groceryList.flattenedGroceries()
    }()

    
    @IBAction func onClearAll() {
        // 1
      let indices = NSIndexSet(indexesInRange: NSRange(location: 0, length: table.numberOfRows))
      table.removeRowsAtIndexes(indices)
      
      // 2
      groceryList.removeAllItems()
      groceryList.sync()
      
      // 3
      for (index, listItem) in enumerate(flatList) {
        if let item = listItem.item as? Ingredient {
          item.purchased = false
        }
      }
      
      // 4
      flatList = self.groceryList.flattenedGroceries()
    }
    
    @IBAction func onRemovePurchased() {
        // 1
      var indexSet = NSMutableIndexSet()
      
      // 2
      for (index, listItem) in enumerate(flatList) {
        if let item = flatList[index].item as? Ingredient {
          if item.purchased {
            indexSet.addIndex(index)
            groceryList.removeItem(item)
          }
        }
      }
      groceryList.sync()
      
      // 3
      table.removeRowsAtIndexes(indexSet)
      flatList = self.groceryList.flattenedGroceries()
    }
    
    
  var cellTextAttributes: [NSObject: AnyObject] {
    return [
      NSFontAttributeName: UIFont.systemFontOfSize(16),
      NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
  }

  var strikethroughCellTextAttributes: [NSObject: AnyObject] {
    return [
      NSFontAttributeName: UIFont.systemFontOfSize(16),
      NSForegroundColorAttributeName: UIColor.lightGrayColor(),
      NSStrikethroughStyleAttributeName:
        NSUnderlineStyle.StyleSingle.rawValue
    ]
  }

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    updateTable()
  }

  func updateTable() {
    table.setRowTypes(flatList.map({ $0.id }))

    for i in 0..<table.numberOfRows {
      // 1
      let controller: AnyObject! = table.rowControllerAtIndex(i)
      let context = flatList[i]

      // 2
      if let row = controller as? GroceryTypeRowController {
        let type = context.item as! String
        row.textLabel.setText(type)
        row.image.setImageNamed(type.lowercaseString)
        // 3
      } else if let row = controller as? GroceryRowController {
        let item = context.item as! Ingredient

        if item.purchased {
          let attributes = strikethroughCellTextAttributes
          let attributedText = NSAttributedString(string:
            item.name.capitalizedString, attributes: attributes)
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

  override func table(table: WKInterfaceTable,
    didSelectRowAtIndex rowIndex: Int) {
      if let row = table.rowControllerAtIndex(rowIndex)
        as? GroceryRowController {
          let item = flatList[rowIndex].item as! Ingredient
          let text = item.name.capitalizedString

          var attributes: [NSObject: AnyObject]?

          // attributes code
          if item.purchased {
            attributes = cellTextAttributes
          } else {
            attributes = strikethroughCellTextAttributes
          }

          groceryList.setIngredient(item, purchased: !item.purchased)
          groceryList.sync()

          let attributedText = NSAttributedString(string: text,
            attributes: attributes)
          row.textLabel.setAttributedText(attributedText)
      }
  }

}
