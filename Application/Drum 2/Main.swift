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
    
    // MARK: Globals
    
    var window: UIWindow?
    
    // MARK: Methods
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}

class Main: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    var page = 5
    
    // MARK: Config
    
    var refreshRate = 0.005
    var doneHold    = 200
    
    // MARK: Outlets
    
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UILabel!
    
    // MARK: Globals
    
    var circle: KYCircularProgress!
    var startToggle = false
    var hold = 0
    
    var modifier = 0
    
    // MARK: Methods
    
    
    @IBAction func left() {
        
        if !startToggle {
            if page != 10 {
                page++
            }
            pageControl.currentPage = page
        }
    }
    
    @IBAction func right() {
        
        if !startToggle {
            if page != 0 {
                page--
            }
            pageControl.currentPage = page
        }
    }
    
    
    override func viewDidLoad() {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        changeColor(false)
        
        circle = KYCircularProgress(frame: CGRectMake(0, 0, 170, 170))
        circle.path = UIBezierPath(arcCenter: CGPoint(x: 85, y: 85), radius: CGFloat(80), startAngle: CGFloat(3 * M_PI/2), endAngle: CGFloat(11), clockwise: true)
        circle.colors = [UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()]
        circle.lineWidth = 10
        circle.showProgressGuide = true
        circle.progressGuideColor = UIColor(white: 1, alpha: 0.2)
        
        progress.addSubview(circle)
        
        NSTimer.scheduledTimerWithTimeInterval(refreshRate, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Initially show help view
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        if !launchedBefore  {
            help()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
        }
    }
    
    func update() {
        var seconds = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second
        
        print("Real Seconds: \(seconds)")
        
        
        // Change background color
        //changeColor(true)
        
        var progress = UInt8(Float(seconds % 10))
        
        // Update interface measures
        
        
        
        
        
        if page == 0 {
            progress = 50 + progress
            label.text = "-\(progress)s"
            seconds = seconds + 10
            
        } else if page == 1 {
            progress = 40 + progress
            label.text = "-\(progress)s"
            seconds = seconds + 20
            
        } else if page == 2 {
            progress = 30 + progress
            label.text = "-\(progress)s"
            seconds = seconds + 30
            
        } else if page == 3 {
            progress = 20 + progress
            label.text = "-\(progress)s"
            seconds = seconds + 40
            
        } else if page == 4 {
            progress = 10 + progress
            label.text = "-\(progress)s"
            seconds = seconds + 50
            
        } else if page == 5 {
            progress = 0 + progress
            label.text = "\(10 - progress)s"
            seconds = seconds + 0
            
        } else if page == 6 {
            progress = 10 + progress
            label.text = "\(30 - progress)s"
            seconds = seconds + 10
            
        } else if page == 7 {
            progress = 20 + progress
            label.text = "\(50 - progress)s"
            seconds = seconds + 20
            
        } else if page == 8 {
            progress = 30 + progress
            label.text = "\(70 - progress)s"
            seconds = seconds + 30
            
        } else if page == 9 {
            progress = 40 + progress
            label.text = "\(90 - progress)s"
            seconds = seconds + 40
            
        } else if page == 10 {
            progress = 50 + progress
            label.text = "\(110 - progress)s"
            seconds = seconds + 50
            
        }
        
        var color = UIColor()
        
        if seconds >= 0 && seconds < 10 { // 0 to 9
            color = UIColor(red:1, green:0.4, blue:0.4, alpha:1)
        } else if seconds >= 10 && seconds < 20 { // 10 to 19
            color = UIColor(red:1, green:0.8, blue:0.43, alpha:1)
        } else if seconds >= 20 && seconds < 30 { // 20 to 29
            color = UIColor(red:0.78, green:0.77, blue:0.35, alpha:1)
        } else if seconds >= 30 && seconds < 40 { // 30 to 39
            color = UIColor(red:0.24, green:0.79, blue:0.42, alpha:1)
        } else if seconds >= 40 && seconds < 50 { // 40 to 49
            color = UIColor(red:0.09, green:0.51, blue:0.98, alpha:1)
        } else if seconds >= 50 && seconds < 60 { // 50 to 59
            color = UIColor(red:0.8, green:0.42, blue:0.99, alpha:1)
        } else {
            color = UIColor.blackColor()
        }
        
        view.backgroundColor = color
        
        
        
        
        
        circle.progress = Double(progress) / 10
        
        // Shows Done message after syncing
        if hold > 0 {
            hold--
            button.text = "Done!"
        } else {
            if !startToggle {
                button.text = "Tap to Sync"
            } else {
                button.text = "Cancel"
            }
        }
        
        // Fire if appropriate
        if seconds % 10 == 0 && startToggle  {
            print("Synced")
            
            startToggle = false
            hold = hold + doneHold
            
            let player = MPMusicPlayerController.systemMusicPlayer()
            
            player.skipToBeginning()
            player.play()
        }
    }
    
    func changeColor(animated: Bool) {
        
        let seconds = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second
        
        var color = UIColor()
        
        if seconds >= 0 && seconds < 10 { // 0 to 9
            color = UIColor(red:1, green:0.4, blue:0.4, alpha:1)
        } else if seconds >= 10 && seconds < 20 { // 10 to 19
            color = UIColor(red:1, green:0.8, blue:0.43, alpha:1)
        } else if seconds >= 20 && seconds < 30 { // 20 to 29
            color = UIColor(red:0.78, green:0.77, blue:0.35, alpha:1)
        } else if seconds >= 30 && seconds < 40 { // 30 to 39
            color = UIColor(red:0.24, green:0.79, blue:0.42, alpha:1)
        } else if seconds >= 40 && seconds < 50 { // 40 to 49
            color = UIColor(red:0.09, green:0.51, blue:0.98, alpha:1)
        } else if seconds >= 50 && seconds < 60 { // 50 to 59
            color = UIColor(red:0.8, green:0.42, blue:0.99, alpha:1)
        }
        
        if animated {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    UIView.animateWithDuration(0.75, animations: {
                        self.view.backgroundColor = color
                    })
                }
            }
        } else {
            view.backgroundColor = color
        }
    }
    
    func change() {
        if startToggle {
            startToggle = false
            button.text = "Tap to Sync"
            pageControl.hidden = false
        } else {
            startToggle = true
            button.text = "Cancel"
            pageControl.hidden = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func start() {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let seconds = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second
        
        // Make up for overlap
        if seconds % 10 == 0  {
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "change", userInfo: nil, repeats: false)
        } else {
            change()
        }
    }
    
    @IBAction func help() {
        let alert: UIAlertController = UIAlertController(title: "Help", message: "1. Open the Music app and play the same song on each device.\n\n2. Reopen Strum and tap “Tap to Sync.” Each device must tap anytime within the same color window.\n\n3. Wait for the 10-second countdown to expire and enjoy your multi-device music!", preferredStyle: .Alert)
        //alert.view.tintColor = UIColor(red:1, green:0.4, blue:0.4, alpha:1)
        alert.addAction(UIAlertAction(title: "Okay", style: .Cancel) { action -> Void in })
        presentViewController(alert, animated: true, completion: nil)
    }
}
