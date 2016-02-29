//
//  ViewController.swift
//  Strum
//
//  Created by Charles Fries on 7/18/15.
//  Copyright © 2015 Figure Inc. All rights reserved.
//

import UIKit
import MediaPlayer
import iAd
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

}

// MAIN ////////////////////////////////////////////////////////////////////////////////////////////////////
class Main: UIViewController {
    
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var status: UILabel!
    var shouldFire = false
    
    @IBOutlet weak var progress: UIView!
    var circle: KYCircularProgress!
    
    @IBOutlet var lastColor: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    var page = 5
    
    override func viewDidLoad() {
        
        circle = KYCircularProgress(frame: CGRectMake(0, 0, 170, 170))
        circle.path = UIBezierPath(arcCenter: CGPoint(x: 85, y: 85), radius: CGFloat(80), startAngle: CGFloat(3 * M_PI/2), endAngle: CGFloat(11), clockwise: true)
        circle.colors = [UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()]
        circle.lineWidth = 10
        circle.showProgressGuide = true
        circle.progressGuideColor = UIColor(white: 1, alpha: 0.2)
        
        progress.addSubview(circle)
        
        timer()
        
        scheduleNextTick()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func scheduleNextTick() {
        let timeSinceReferenceDate = NSDate.timeIntervalSinceReferenceDate()
        let delayToNextSecond: Double = ceil(timeSinceReferenceDate) - timeSinceReferenceDate
        
        delay(delayToNextSecond) {
            
            self.timer()
            self.scheduleNextTick()
            
        }
    }
    
    func timer() {
        
        let sixtyTime = Int(NSDate.timeIntervalSinceReferenceDate() % 60)
        
        let tenTime = (sixtyTime % 10)
        
        self.clock.text = "\(10 - tenTime)s"
        self.circle.progress = Double((sixtyTime + 1) % 10) / 10
        
        var modifier = 0
        
        if page == 0 {
            modifier = 50
        } else if page == 1 {
            modifier = 40
        } else if page == 2 {
            modifier = 30
        } else if page == 3 {
            modifier = 20
        } else if page == 4 {
            modifier = 10
        } else if page == 5 {
            modifier = 0
        }
        
        let newSeconds = sixtyTime - modifier
        
        var lastStrum = ""
        
        var color = UIColor()
        
        // Red
        if (newSeconds >= 0 && newSeconds < 10) || (newSeconds >= -60 && newSeconds < -50) {
            color = UIColor(red:1, green:0.4, blue:0.4, alpha:1)
            lastStrum = "▷ Purple"
        }
            
        // Orange
        else if (newSeconds >= 10 && newSeconds < 20) || (newSeconds >= -50 && newSeconds < -40) {
            color = UIColor(red:0.99, green:0.5, blue:0.14, alpha:1)
            lastStrum = "▷ Red"
        }
            
        // Yellow
        else if (newSeconds >= 20 && newSeconds < 30) || (newSeconds >= -40 && newSeconds < -30) {
            color = UIColor(red:0.89, green:0.89, blue:0.19, alpha:1)
            lastStrum = "▷ Orange"
        }
            
        // Green
        else if (newSeconds >= 30 && newSeconds < 40) || (newSeconds >= -30 && newSeconds < -20) {
            color = UIColor(red:0.24, green:0.79, blue:0.42, alpha:1)
            lastStrum = "▷ Yellow"
        }
            
        // Blue
        else if (newSeconds >= 40 && newSeconds < 50) || (newSeconds >= -20 && newSeconds < -10) {
            color = UIColor(red:0.09, green:0.51, blue:0.98, alpha:1)
            lastStrum = "▷ Green"
        }
            
        // Purple
        else if (newSeconds >= 50 && newSeconds < 60) || (newSeconds >= -10 && newSeconds < 0) {
            color = UIColor(red:0.8, green:0.42, blue:0.99, alpha:1)
            lastStrum = "▷ Blue"
        }
            
        else {
            color = UIColor.blackColor()
        }
        
        
        
        
        
        
        if shouldFire {
            fire()
        } else if newSeconds < 0 {
            print("Seconds are less than the fire time")
        } else {
            print("No match")
        }
        
        
        view.backgroundColor = UIColor.redColor()
        
        
        
        
        
        
        view.backgroundColor = color
        
        if tenTime % 10 == 0 && shouldFire {
            
            print("Synced")
            
            fire()
            
            let player = MPMusicPlayerController.systemMusicPlayer()
            player.pause()
            player.skipToBeginning()
            player.play()
            
            lastColor.text = lastStrum
        }
    }
    
    @IBAction func fire() {
        if shouldFire {
            shouldFire = false
            status.text = "Tap to Sync"
        } else {
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            shouldFire = true
            status.text = "Cancel"
        }
    }
}

// INFO ////////////////////////////////////////////////////////////////////////////////////////////////////
class Info: UITableViewController {
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
            } else if indexPath.row == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://usefigure.com/faq")!)
            } else if indexPath.row == 2 {
                UIApplication.sharedApplication().openURL(NSURL(string: "mailto:support@usefigure.com")!)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://usefigure.com/strum")!)
            } else if indexPath.row == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://usefigure.com")!)
            } else if indexPath.row == 2 {
                
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}