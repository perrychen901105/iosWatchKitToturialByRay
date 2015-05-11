
import WatchKit
import SousChefKit

class InitialInterfaceController: WKInterfaceController {
  let fileManager = NSFileManager.defaultManager()
  override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
    println("Received a Handoff payload: \(userInfo)")
    if let version = userInfo![kHandoffVersionKey] as? String {
      if version == kHandoffVersionNumber {
        if let nextItem = userInfo![kGlanceHandoffNextItemKey] as? String {
          self.pushControllerWithName("GroceryController", context: nextItem)
        }
      }
    }
  }
  
  override func willActivate() {
    super.willActivate()
    setupGroceryListGroupDoc()
  }
  
  func createNewGroceryListDoc() {
    let newGroceryListDoc = GroceryList(fileURL: GroceryListConfig.url)
    newGroceryListDoc.saveToURL(newGroceryListDoc.fileURL, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: { success in
      if success {
        println("createNewGroceryListDoc: success")
      } else {
        println("createNewGroceryListDoc: failed")
      }
    })
  }
  
  func setupGroceryListGroupDoc() {
    GroceryListConfig.url = GroceryListConfig.groupURL
    // check for existing doc; create one if none exists
    if !fileManager.fileExistsAtPath(GroceryListConfig.url.path!) {
      println("setupGroceryListGroupDoc: create empty group doc")
      createNewGroceryListDoc()
    }
  }
  // 1
  let recipeStore = RecipeStore()
  
  // 2
  override func handleActionWithIdentifier(identifier: String?, forLocalNotification localNotification: UILocalNotification) {
    if let userInfo = localNotification.userInfo {
      processActionWithIdentifier(identifier, withUserInfo: userInfo)
    }
  }
  
  // 3
  override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
    processActionWithIdentifier(identifier, withUserInfo: remoteNotification)
  }
  
  func processActionWithIdentifier(identifier: String?, withUserInfo userInfo: [NSObject: AnyObject]) {
    // 1
    if identifier == "viewDirectionsButtonAction" {
      // 2
      if let title = userInfo["title"] as? String {
        // 3
        println("the title is \(title)")
        let matchingRecipes = recipeStore.recipes.filter({$0.name == title})
        for obj in enumerate(recipeStore.recipes) {
          println("the obj is \(obj)")
        }
        
        
        println("the recipes is \(matchingRecipes)")
        // 4
        pushControllerWithName("RecipeDirections", context: recipeStore.recipes[8])
      }
    }
  }
  
}
