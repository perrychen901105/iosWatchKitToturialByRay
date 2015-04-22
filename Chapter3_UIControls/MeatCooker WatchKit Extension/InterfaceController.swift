
import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var weightLabel: WKInterfaceLabel!
    @IBOutlet weak var cookLabel: WKInterfaceLabel!
    @IBOutlet weak var timerButton: WKInterfaceButton!
    
    
    var ounces = 16
    var cookTemp = MeatTemperature.Medium
    var timerRunning = false
    var usingMetric = false
    
  override func awakeWithContext(context: AnyObject?) {
      super.awakeWithContext(context)
    updateConfiguration()
  }

    func updateConfiguration() {
        // 1
        // the measurement system doesn't affect the cooking temperature, so you don't alter this line
        cookLabel.setText(cookTemp.stringValue)
        
        var weight = ounces
        var unit = "oz"
        
        if usingMetric {
            // 2
            let grams = Double(ounces) * 28.3495
            weight = Int(grams)
            unit = "gm"
        }
        
        weightLabel.setText("Weight: \(weight) \(unit)")
    }
    
    @IBAction func onTempChange(value: Float) {
        if let temp = MeatTemperature(rawValue: Int(value)) {
            cookTemp = temp
            updateConfiguration()
        }
    }
    
    @IBAction func onMinusButton() {
        ounces--
        updateConfiguration()
    }

    @IBAction func onPlusButton() {
        ounces++
        updateConfiguration()
    }
    
    @IBAction func onMetricChanged(value: Bool) {
        usingMetric = value
        updateConfiguration()
    }
    
    @IBAction func onTimerButton() {
        // 1
        if timerRunning {
            timer.stop()
            timerButton.setTitle("Start Timer")
        } else {
            // 2
            let time = cookTimeForOunces(ounces, cookTemp: cookTemp)
            timer.setDate(NSDate(timeIntervalSinceNow: time))
            timer.start()
            timerButton.setTitle("Stop Timer")
        }
        // 3
        timerRunning = !timerRunning
    }
    
    // 1
    func cookTimeForOunces(ounces: Int, cookTemp: MeatTemperature) -> NSTimeInterval {
        // 2
        let baseTime: NSTimeInterval = 47 * 60
        let baseWeight = 16
        // 3
        let weightModifier: Double = Double(ounces) / Double(baseWeight)
        let tempModifier = cookTemp.timeModifier
        return baseTime * weightModifier * tempModifier
    }
}
