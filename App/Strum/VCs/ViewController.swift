//
//  ViewController.swift
//  Strum
//
//  Created by Charles Fries on 7/18/15.
//  Copyright © 2015 Charles Fries. All rights reserved.
//

import UIKit
import MediaPlayer
import AudioToolbox

class ViewController: UIViewController, MPMediaPickerControllerDelegate
{
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var progress: UIView!
    
    var shouldFire = false
    var circle: KYCircularProgress!
    var page = 5
    
    override func viewDidLoad()
    {
        setUpProgress()
        loop()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUpProgress()
    {
        circle = KYCircularProgress(frame: CGRect(x: 0, y: 0, width: 170, height: 170))
        
        circle.path = UIBezierPath(arcCenter: CGPoint(x: 85, y: 85), radius: CGFloat(80), startAngle: CGFloat(3 * M_PI/2), endAngle: CGFloat(11), clockwise: true)
        circle.colors = [UIColor.white, UIColor.white, UIColor.white, UIColor.white]
        circle.lineWidth = 10
        circle.showProgressGuide = true
        circle.progressGuideColor = UIColor(white: 1, alpha: 0.2)
        
        progress.addSubview(circle)
    }
    
    func loop()
    {
        let refDate = Date.timeIntervalSinceReferenceDate
        let delayToSec: Double = ceil(refDate) - refDate
        delay(delayToSec) { self.loop() }
        
        let tick = Int(NSDate.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
        
        if checkParams(tick: tick, initiated: shouldFire)
        {
            initiate()
            playAudio()
        }
        
        updateInterface(tick: tick)
    }
    
    func updateInterface(tick: Int)
    {
        clock.text = "\(10 - (tick % 10))s"
        circle.progress = Double((tick + 1) % 10) / 10
        
        var color = UIColor()
        
        if      tick < 10 { color = UIColor(red:1,    green:0.4,  blue:0.4,  alpha:1) } // Red
        else if tick < 20 { color = UIColor(red:0.99, green:0.5,  blue:0.14, alpha:1) } // Orange
        else if tick < 30 { color = UIColor(red:0.89, green:0.89, blue:0.19, alpha:1) } // Yellow
        else if tick < 40 { color = UIColor(red:0.24, green:0.79, blue:0.42, alpha:1) } // Green
        else if tick < 50 { color = UIColor(red:0.09, green:0.51, blue:0.98, alpha:1) } // Blue
        else if tick < 60 { color = UIColor(red:0.8,  green:0.42, blue:0.99, alpha:1) } // Purple
        
        view.backgroundColor = color
    }
    
    func delay(_ delay:Double, closure:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func checkParams(tick: Int, initiated: Bool) -> Bool
    {
        return tick % 10 == 0 && initiated
    }
    
    func playAudio()
    {
        let player = MPMusicPlayerController.systemMusicPlayer()
        player.pause()
        player.skipToBeginning()
        player.play()
    }
    
    @IBAction func initiate()
    {
        if shouldFire
        {
            shouldFire = false
            status.text = "Tap to Sync"
        }
        else
        {
            shouldFire = true
            status.text = "Cancel"
            
            if #available(iOS 10.0, *)
            {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
            else
            {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
}
