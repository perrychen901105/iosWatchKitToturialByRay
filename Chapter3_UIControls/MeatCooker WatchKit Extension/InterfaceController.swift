
import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var timer: WKInterfaceTimer!
    
    
  override func awakeWithContext(context: AnyObject?) {
      super.awakeWithContext(context)
  }

    @IBAction func onTimerButton() {
        // 1
        let countdown: NSTimeInterval = 20
        let date = NSDate(timeIntervalSinceNow: countdown)
        // 2
        timer.setDate(date)
        timer.start()
    }
}
