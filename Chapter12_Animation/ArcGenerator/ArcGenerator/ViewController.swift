//
//  ViewController.swift
//  ArcGenerator
//
//  Created by Jack Wu on 2014-12-09.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    // 1
    let generator = ArcGenerator()
    let width = 10
    let radius = 60
    let gap = 2
    
    // 2
    var animation = ArcAnimation.progressArcAnimation()
    animation.totalFrames = 100
    animation.name = "progressRed"
    
    // 3
    animation.initialArc = Arc(radius: radius,
      lineWidth: width, padding: 0,
      startAngle: 3.0 * M_PI / 2.0, endAngle: 3.0 * M_PI / 2.0,
      clockwise: true, color: UIColor.magentaColor())
    animation.initialArc.emptyArcColor = UIColor.magentaColor().colorWithAlphaComponent(0.3)
    animation.initialArc.lineWidth = width
    
    // 4
    generator.generateArcAnimationFrames(animation)
    
    animation = ArcAnimation.progressArcAnimation()
    animation.totalFrames = 100
    animation.name = "progressCyan"
    animation.initialArc = Arc(radius: radius - (width + gap), lineWidth: width, padding: width + gap, startAngle: 3.0 * M_PI / 2.0, endAngle: 3.0 * M_PI / 2.0, clockwise: true, color: UIColor.cyanColor())
    animation.initialArc.emptyArcColor = UIColor.cyanColor().colorWithAlphaComponent(0.3)
    generator.generateArcAnimationFrames(animation)
    
    animation = ArcAnimation.progressArcAnimation()
    animation.totalFrames = 100
    animation.name = "progreessGreen"
    animation.initialArc = Arc(radius: radius - (width + gap) * 2, lineWidth: width, padding: (width + gap) * 2, startAngle: 3.0 * M_PI / 2.0, endAngle: 3.0 * M_PI / 2.0, clockwise: true, color: UIColor.greenColor())
    animation.initialArc.emptyArcColor = UIColor.greenColor().colorWithAlphaComponent(0.3)
    generator.generateArcAnimationFrames(animation)

//    let generator = ArcGenerator()
//    let animation = ArcAnimation.progressArcAnimation()
//    animation.name = "progress"
//    animation.initialArc.color = UIColor.magentaColor()
//    animation.initialArc.emptyArcColor = UIColor.magentaColor().colorWithAlphaComponent(0.3)
//    generator.generateArcAnimationFrames(animation)
    
//    let generator = ArcGenerator()
//    let animation = ArcAnimation.spinningArcAnimation()
//    animation.name = "spinning"
//    generator.generateArcAnimationFrames(animation)
//    
//    let animation2 = ArcAnimation.progressArcAnimation()
//    animation2.name = "progress"
//    generator.generateArcAnimationFrames(animation2)
  }
  
}

