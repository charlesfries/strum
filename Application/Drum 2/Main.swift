//
//  Main.swift
//  Symphony
//
//  Created by Charles Fries on 7/5/15.
//  Copyright (c) 2015 Figure Inc. All rights reserved.
//

import UIKit
import MediaPlayer
import iAd
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}

class Main: UIViewController {
    
    @IBOutlet weak var progress: UIView!
    var circle: KYCircularProgress!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UILabel!
    var startToggle = false
    
    override func viewDidLoad() {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        circle = KYCircularProgress(frame: CGRectMake(0, 0, 170, 170))
        circle.path = UIBezierPath(arcCenter: CGPoint(x: 85, y: 85), radius: CGFloat(80), startAngle: CGFloat(3 * M_PI/2), endAngle: CGFloat(11), clockwise: true)
        circle.colors = [UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()]
        circle.lineWidth = 10
        circle.showProgressGuide = true
        circle.progressGuideColor = UIColor(white: 1, alpha: 0.2)
        
        progress.addSubview(circle)
        
        NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    func update() {
        
        let seconds = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second
        
        label.text = "\(10 - (seconds % 10))s"
        circle.progress = Double(seconds % 10) / 10
        
        let newSeconds = seconds
        
        var color = UIColor()
        
        // Red
        if (newSeconds >= 0 && newSeconds < 10) || (newSeconds >= -60 && newSeconds < -50) {
            color = UIColor(red:1, green:0.4, blue:0.4, alpha:1)
        }
            
        // Orange
        else if (newSeconds >= 10 && newSeconds < 20) || (newSeconds >= -50 && newSeconds < -40) {
            color = UIColor(red:0.99, green:0.5, blue:0.14, alpha:1)
        }
            
        // Yellow
        else if (newSeconds >= 20 && newSeconds < 30) || (newSeconds >= -40 && newSeconds < -30) {
            color = UIColor(red:0.89, green:0.89, blue:0.19, alpha:1)
        }
            
        // Green
        else if (newSeconds >= 30 && newSeconds < 40) || (newSeconds >= -30 && newSeconds < -20) {
            color = UIColor(red:0.24, green:0.79, blue:0.42, alpha:1)
        }
            
        // Blue
        else if (newSeconds >= 40 && newSeconds < 50) || (newSeconds >= -20 && newSeconds < -10) {
            color = UIColor(red:0.09, green:0.51, blue:0.98, alpha:1)
        }
            
        // Purple
        else if (newSeconds >= 50 && newSeconds < 60) || (newSeconds >= -10 && newSeconds < 0) {
            color = UIColor(red:0.8, green:0.42, blue:0.99, alpha:1)
        }
        
        else {
            color = UIColor.blackColor()
        }
        
        view.backgroundColor = color
        
        if seconds % 10 == 0 && startToggle  {
            print("Synced")
            
            startToggle = false
            button.text = "Tap to Sync"
            
            let player = MPMusicPlayerController.systemMusicPlayer()
            player.pause()
            player.skipToBeginning()
            player.play()
            
        }
    }
    
    @IBAction func start() {
        
        let seconds = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second
        
        if seconds % 10 != 0 {
            if startToggle {
                startToggle = false
                button.text = "Tap to Sync"
            } else {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                startToggle = true
                button.text = "Cancel"
            }
        }
    }
}
