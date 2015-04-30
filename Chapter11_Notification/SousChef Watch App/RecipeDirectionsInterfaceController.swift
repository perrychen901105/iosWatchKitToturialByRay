
import Foundation
import WatchKit
import SousChefKit

class RecipeDirectionsInterfaceController: WKInterfaceController {
  var recipe: Recipe?

  @IBOutlet weak var table: WKInterfaceTable!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    recipe = context as? Recipe

    if let steps = recipe?.steps {
      table.setNumberOfRows(steps.count, withRowType: "StepRow")

      for (index, step) in enumerate(steps) {
        // 1
        let controller = table.rowControllerAtIndex(index) as! StepRowController
        // 2
        controller.stepLabel.setText("Step \(index + 1)")
        controller.directionsLabel.setText(step)
      }
    }

  }
  
  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    if let timer = recipe?.timers[rowIndex] {
      if timer > 0 {
        let timerSchedulerData = TimerSchedulerData(
          recipe: recipe!,
          stepInstruction: recipe!.steps[rowIndex],
          timer: timer)
        presentControllerWithName("TimerScheduler", context: timerSchedulerData)
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
