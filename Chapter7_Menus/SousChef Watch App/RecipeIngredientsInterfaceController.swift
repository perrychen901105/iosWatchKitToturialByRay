
import Foundation
import WatchKit
import SousChefKit

class RecipeIngredientsInterfaceController: WKInterfaceController {
  var recipe: Recipe?

  @IBOutlet weak var table: WKInterfaceTable!
  
  let groceryList = GroceryList()
  
    @IBAction func onAddToGrocery() {
      if let items = self.recipe?.ingredients {
        for item in items {
          groceryList.addItemToList(item)
        }
        groceryList.sync()
      }
    }
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    recipe = context as? Recipe

    // 1
    if let ingredients = recipe?.ingredients {
      // 2
      table.setNumberOfRows(
        ingredients.count, withRowType: "IngredientRow")

      for (index, ingredient) in enumerate(ingredients) {
        // 3
        let controller = table.rowControllerAtIndex(index) as!
        IngredientRowController
        // 4
        controller.nameLabel.setText(
          ingredient.name.capitalizedString)
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
