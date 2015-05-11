
import UIKit
import SousChefKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let recipeStore = RecipeStore()
  let fileManager = NSFileManager.defaultManager()
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    configureAppearance()
    registerUserNotificationSettings()
    updateRecipesController()
    setupGroceryListGroupDoc()
    return true
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    updateRecipesController()
  }
  
//  func application(application: UIApplication,
//    handleWatchKitExtensionRequest userInfo:
//    [NSObject : AnyObject]!,
//    reply: (([NSObject : AnyObject]!) -> Void)!) {
//      let kGroceryUpdateRequest =
//      "com.raywenderlich.update-recipes"
//      if let updateRecipesRequest =
//        userInfo[kGroceryUpdateRequest] as? Bool {
//          updateRecipesWithRemoteServerWithCompletionBlock {
//            (Void) -> Void in
//            reply(nil)
//          }
//      }
//  }
  
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
  
  func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
    
    if let userInfo = userInfo as [NSObject : AnyObject]! {
      if let category = userInfo["category"] as? String {
        // 2
        if ((application.currentUserNotificationSettings().types & UIUserNotificationType.Alert) != nil) && category == "timer" {
          scheduleTimerNotificationWithUserInfo(userInfo)
          if (reply != nil) {
            reply(nil)
          }
        }
      } else {
        let kGroceryUpdateRequest =
        "com.raywenderlich.update-recipes"
        if let updateRecipesRequest =
          userInfo[kGroceryUpdateRequest] as? String {
            println("\(updateRecipesRequest)")
            updateRecipesWithRemoteServerWithCompletionBlock {
              (Void) -> Void in
              reply(["hello": updateRecipesRequest])
            }
        }
      }
    }
    
  }
  
  
  // MARK: - Updates
  
  func updateRecipesWithRemoteServerWithCompletionBlock(block:((Void) -> Void)?) {
    recipeStore.refresh(completion: {
      (recipes, error) -> Void in
      if let block = block {
        block()
      }
    })
  }
  
  // 2
  func updateRecipesController() {
    updateRecipesWithRemoteServerWithCompletionBlock { (Void) -> Void in
      if let tabBarController = self.window?.rootViewController as? UITabBarController {
        if let navigationController = tabBarController.viewControllers?.first as? UINavigationController {
          if let recipesController = navigationController.viewControllers?.first as? RecipesController {
            recipesController.reloadContent()
          }
        }
      }
    }
  }
  
  // MARK: - Appearance

  func configureAppearance() {
    let navBarAppearance = UINavigationBar.appearance()
    navBarAppearance.titleTextAttributes = [
      NSForegroundColorAttributeName: Theme.navTextColor,
      NSFontAttributeName: Theme.navFont!
    ]
    navBarAppearance.barTintColor = Theme.baseColor
    navBarAppearance.tintColor = Theme.navTextColor

    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.tintColor = Theme.baseColor
  }
  
  // MARK: - Notification Setup
  
  func registerUserNotificationSettings() {
    let viewDirectionsAction = UIMutableUserNotificationAction()
    viewDirectionsAction.identifier = "viewDirectionsButtonAction"
    viewDirectionsAction.title = "View Directions"
    viewDirectionsAction.activationMode = .Foreground
    viewDirectionsAction.authenticationRequired = false
    
    let viewRecipeAction = UIMutableUserNotificationAction()
    viewRecipeAction.identifier = "viewRecipeButtonAction"
    viewRecipeAction.title = "View Recipe"
    viewRecipeAction.activationMode = .Foreground
    viewRecipeAction.authenticationRequired = false
    
    let timerCategory = UIMutableUserNotificationCategory()
    timerCategory.identifier = "timer"
    timerCategory.setActions([viewDirectionsAction], forContext: .Default)
    
    let newRecipeCategory = UIMutableUserNotificationCategory()
    newRecipeCategory.identifier = "new_recipe"
    newRecipeCategory.setActions([viewRecipeAction], forContext: .Default)
    
    let categories = NSSet(array: [timerCategory, newRecipeCategory])
    
    let settings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: categories as Set<NSObject>)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
  }
  
  func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    if (notificationSettings.types & UIUserNotificationType.Alert) != nil {
      application.registerForRemoteNotifications()
    }
  }
  
  // MARK: - Remote Notifications
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    println("Register for remote notifications with device token: \(deviceToken).")
    // TODO: Send device token to push notification service of choice. See appendix on Setting up a Push Notification Server.
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    println("Failed to register for remote notifications. Make sure you are running on an actual device and check the Provisioning Profile.")
    println(error.localizedDescription)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    if let aps = userInfo["aps"] as? NSDictionary {
      if let category = aps["category"] as? String {
        if category == "new_recipe" {
          let title = userInfo["title"]! as! String
          let message = userInfo["message"]! as! String
          
          let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
          alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
          alert.addAction(UIAlertAction(title: "View Recipe", style: .Default, handler: { _ in
            //
            // TODO: Call sync/refresh method when a new recipe is received
            //
            self.showRecipeWithUserInfo(userInfo, andInitialController: .Ingredients)
          }))
          
          let tabBarController = window?.rootViewController! as! UITabBarController
          let recipesNavigationController = tabBarController.viewControllers![0] as! UINavigationController
          recipesNavigationController.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  }
  
  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
    if identifier == "viewRecipeButtonAction" {
        //
        // TODO: Call sync/refresh method when a new recipe is received
        //
        showRecipeWithUserInfo(userInfo, andInitialController: .Ingredients)
    }
    completionHandler()
  }
  
  // MARK: - Local Notifications
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    if let userInfo = notification.userInfo {
      if let category = userInfo["category"] as? String {
        if category == "timer" {
          let title = userInfo["title"]! as! String
          let message = userInfo["message"]! as! String

          let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
          alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
          alert.addAction(UIAlertAction(title: "View Directions", style: .Default, handler: { _ in
            self.showRecipeWithUserInfo(userInfo, andInitialController: .Steps)
          }))
          
          let tabBarController = window?.rootViewController! as! UITabBarController
          let recipesNavigationController = tabBarController.viewControllers![0] as! UINavigationController
          recipesNavigationController.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  }
  
  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
    if identifier == "viewDirectionsButtonAction" {
      if let userInfo = notification.userInfo {
        showRecipeWithUserInfo(userInfo, andInitialController: .Steps)
      }
    }
    completionHandler()
  }
  
  func showRecipeWithUserInfo(userInfo: [NSObject : AnyObject]!, andInitialController initialController: RecipeDetailSelection) {
    if let title = userInfo["title"] as? String {
      let matchingRecipes = recipeStore.recipes.filter({$0.name == title})
      let tabBarController = window?.rootViewController! as! UITabBarController
      let recipesNavigationController = tabBarController.viewControllers![0] as! UINavigationController
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let recipeDetailController = mainStoryboard.instantiateViewControllerWithIdentifier("RecipeDetail") as! RecipeDetailController
      recipeDetailController.recipe = matchingRecipes[0]
      recipeDetailController.initialController = initialController
      recipesNavigationController.pushViewController(recipeDetailController, animated: true)
      tabBarController.selectedIndex = 0
    }
  }
  
  func scheduleTimerNotificationWithUserInfo(userInfo: [NSObject : AnyObject]!) {

    let application = UIApplication.sharedApplication()
    if (application.currentUserNotificationSettings().types & UIUserNotificationType.Alert) != nil {
      let message = userInfo["message"] as! String
      let title = userInfo["title"] as! String
      let timer = userInfo["timer"] as! Int
      let fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(timer * 60))
      
      let notification = UILocalNotification()
      notification.fireDate = fireDate
      notification.alertTitle = title
      notification.alertBody = message
      notification.soundName = UILocalNotificationDefaultSoundName
      notification.category = "timer"
      notification.userInfo = userInfo
      
      application.scheduleLocalNotification(notification)
    }
  }

}
