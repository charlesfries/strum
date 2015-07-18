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
    
    @IBOutlet var lastColor: UILabel!
    //@IBOutlet var marker: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    var page = 5
    
    override func viewDidLoad() {
        
        lastColor.hidden = true
        
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
        
        print("Real: \(seconds)")
        
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
        
        let progress = seconds % 10
        //label.text = "\(((modifier * 2) + 10) - (progress + modifier))s"
        label.text = "\(10 - progress)s"
        circle.progress = Double(progress) / 10
        
        let newSeconds = seconds - modifier
        
        print(" Mod: \(modifier)")
        print(" New: \(newSeconds)")
        
        // Color Selection //////////////////////////////////////////////////
        var color = UIColor()
        // Red
        if (newSeconds >= 0 && newSeconds < 10) || (newSeconds >= -60 && newSeconds < -50) {
            color = UIColor(red:1, green:0.4, blue:0.4, alpha:1)
        }
        // Orange
        else if (newSeconds >= 10 && newSeconds < 20) || (newSeconds >= -50 && newSeconds < -40) {
            color = UIColor(red:1, green:0.8, blue:0.43, alpha:1)
        }
        // Yellow
        else if (newSeconds >= 20 && newSeconds < 30) || (newSeconds >= -40 && newSeconds < -30) {
            color = UIColor(red:0.78, green:0.77, blue:0.35, alpha:1)
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
        // Color Selection //////////////////////////////////////////////////

        
        
        
        
        
        
        
        if seconds % 10 == 0 && startToggle  {
            print("Synced")
            
            start()
            
            let player = MPMusicPlayerController.systemMusicPlayer()
            //player.skipToBeginning()
            player.currentPlaybackTime = NSTimeInterval(modifier)
            player.play()
            
            lastColor.hidden = false
            
            // Red
            if (newSeconds >= 0 && newSeconds < 10) || (newSeconds >= -60 && newSeconds < -50) {
                lastColor.text = "▷ Purple"
            }
                // Orange
            else if (newSeconds >= 10 && newSeconds < 20) || (newSeconds >= -50 && newSeconds < -40) {
                lastColor.text = "▷ Red"
            }
                // Yellow
            else if (newSeconds >= 20 && newSeconds < 30) || (newSeconds >= -40 && newSeconds < -30) {
                lastColor.text = "▷ Orange"
            }
                // Green
            else if (newSeconds >= 30 && newSeconds < 40) || (newSeconds >= -30 && newSeconds < -20) {
                lastColor.text = "▷ Yellow"
            }
                // Blue
            else if (newSeconds >= 40 && newSeconds < 50) || (newSeconds >= -20 && newSeconds < -10) {
                lastColor.text = "▷ Green"
            }
                // Purple
            else if (newSeconds >= 50 && newSeconds < 60) || (newSeconds >= -10 && newSeconds < 0) {
                lastColor.text = "▷ Blue"
            }
            else {
                lastColor.text = "▷ Black"
            }
        }
    }
    
    @IBAction func start() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        
        if startToggle {
            startToggle = false
            button.text = "Tap to Sync"
            //pageControl.hidden = false
            //marker.hidden = false
        } else {
            startToggle = true
            button.text = "Cancel"
            //pageControl.hidden = true
            //marker.hidden = true
        }
    }
    
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
}
