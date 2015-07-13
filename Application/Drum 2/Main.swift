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
    
    // MARK: Config
    
    var refreshRate = 0.005
    var doneHold    = 200
    
    // MARK: Outlets
    
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var message: UILabel!
    
    // MARK: Globals
    
    var circle: KYCircularProgress!
    var toggle = false
    var hold = 0
    
    // MARK: Methods
    
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
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        if !launchedBefore  {
            help()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
        }
    }
    
    func update() {
        let seconds = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second
        
        // Change background color
        changeColor(true)
        
        let progress = UInt8(Float(seconds % 10))
        
        // Update interface measures
        circle.progress = Double(progress) / 10
        label.text = "\(10 - progress)s"
        
        // Shows Done message after syncing
        if hold > 0 {
            hold--
            button.setTitle("Done!", forState: .Normal)
        } else {
            if !toggle {
                button.setTitle("Tap to Sync", forState: .Normal)
                message.text = "Tap at any time in the desired 10 second wndow."
            } else {
                button.setTitle("Cancel", forState: .Normal)
                message.text = "Synced music will play in \((10 - (UInt8(Float(NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second % 10))))) second(s)..."
            }
        }
        
        // Fire if appropriate
        if seconds % 10 == 0 && toggle  {
            print("Synced")
            
            toggle = false
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
            color = UIColor(red:0.88, green:0.84, blue:0.18, alpha:1)
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
        if toggle {
            toggle = false
            button.setTitle("Tap to Sync", forState: .Normal)
            message.text = "Tap at any time in the desired 10 second wndow."
        } else {
            toggle = true
            button.setTitle("Cancel", forState: .Normal)
            message.text = "Synced music will play in \((10 - (UInt8(Float(NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second % 10))))) second(s)..."
        }
    }
    
    // MARK: Actions
    
    @IBAction func tap() {
        let seconds = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate()).second
        
        // Make up for overlap
        if seconds % 10 == 0  {
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "change", userInfo: nil, repeats: false)
        } else {
            change()
        }
    }
    
    @IBAction func help() {
        let alert: UIAlertController = UIAlertController(title: "Help", message: "1. Open the Music app and play a song.\n2. Each party who wants to sync must select Tap to Sync in the same window.\n3. Wait for the window to close, and enjoy listening to your synced music!", preferredStyle: .Alert)
        //alert.view.tintColor = UIColor(red:1, green:0.4, blue:0.4, alpha:1)
        alert.addAction(UIAlertAction(title: "Okay", style: .Cancel) { action -> Void in })
        presentViewController(alert, animated: true, completion: nil)
    }
}
