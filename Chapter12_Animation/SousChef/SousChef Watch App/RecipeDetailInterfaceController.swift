
import Foundation
import WatchKit
import SousChefKit

class RecipeDetailInterfaceController: WKInterfaceController {
  var recipe: Recipe?

    @IBOutlet weak var nameGroup: WKInterfaceGroup!
  @IBOutlet weak var nameLabel: WKInterfaceLabel!

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    recipe = context as? Recipe
    nameLabel.setText(recipe?.name)
    
    // 1 use lastPathComponent() on the URL to determine the name of the image
    if let imageName = recipe?.imageURL?.path?.lastPathComponent {
      // 2
      let cacheHelper = OnDeviceCacheHelper()
      if cacheHelper.cacheContainsImageNamed(imageName) == true {
        nameGroup.setBackgroundImageNamed(imageName);
      } else if let imageURL = recipe?.imageURL {
        // 2 execute it on a background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
          // 3
          let imageData = NSData(contentsOfURL: imageURL)!
          let recipeImage = UIImage(data: imageData)!
          // 4
          let retinaRect = CGRect(x: 0, y: 0, width: self.contentFrame.size.width*2, height: self.contentFrame.size.height*2)
          let resizedImage = recipeImage.resizedImageWithAspectRatioInsideRect(retinaRect)
          let overlayedImage = resizedImage.imageWithOverlayedColor(UIColor.blackColor().colorWithAlphaComponent(0.3))
          
          // 5
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            cacheHelper.addImageToCache(overlayedImage, name: imageName)
            self.nameGroup.setBackgroundImageNamed(imageName)
          })
        })
      }
    }
  }

  override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
    return recipe
  }
}
