//
//  ViewController.swift
//  Strum
//
//  Created by Charles Fries on 7/18/15.
//  Copyright © 2015 Figure Inc. All rights reserved.
//

import UIKit
import MediaPlayer
import AudioToolbox

class MainAlt: UIViewController, MPMediaPickerControllerDelegate
{
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    var shouldFire = false
    var circle: KYCircularProgress!
    var page = 5
    
    override func viewDidLoad()
    {
        loop()
    }
    
    override func viewDidAppear(_ animated: Bool) { }
    
    func loop()
    {
        let refDate = Date.timeIntervalSinceReferenceDate
        let delayToSec: Double = ceil(refDate) - refDate
        
        delay(delayToSec)
        {
            self.loop()
        }
        
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
        //circle.progress = Double((tick + 1) % 10) / 10
        
        progress.setProgress(Float(Double((tick + 1) % 10) / 10), animated: true)
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
            status.text = "Not armed."
            status.textColor = UIColor.red
        }
        else
        {
            shouldFire = true
            status.text = "Armed!"
            status.textColor = UIColor.green
            
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
