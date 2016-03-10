//
//  RecordViewController.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/3/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit
import AVFoundation 

class RecordViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

//    @IBOutlet var recImgView: UIImageView!
    @IBOutlet weak var recImgView: UIImageView!
    @IBOutlet weak var plyBtn: UIBarButtonItem!
    @IBOutlet var recBtnNew: UIButton!
    @IBOutlet var recOkBtn: UIButton!
    @IBOutlet var savedNotification: UILabel!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    var fileName = "micFlagRecording"
    var newFileName = ""
    var recInSession : Bool = false
    var recPaused : Bool = false
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false
        }
        else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait ,UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    func getCacheDirectory() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    func saveFileReference() {
        if userDefaults.objectForKey("micFlagRecordings") != nil {
            var savedData = userDefaults.objectForKey("micFlagRecordings") as! [String]
            savedData.append(newFileName)
            userDefaults.setObject(savedData, forKey: "micFlagRecordings")
            print(userDefaults.objectForKey("micFlagRecordings"))
        } else {
            var newArray = [String]()
            newArray.append(newFileName)
            userDefaults.setObject(newArray, forKey: "micFlagRecordings")
            print(userDefaults.objectForKey("micFlagRecordings"))
        }
    }
    
    func newFileURL() -> NSURL {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Day, .Month, .Year], fromDate: date)
        newFileName = ""
        newFileName = fileName + "_\(components.month)_\(components.day)_\(components.year)_\(components.hour)_\(components.minute)_\(components.second).m4a"
        saveFileReference()
        let path = getCacheDirectory().URLByAppendingPathComponent(newFileName)
        
        print(path)
        return path
    }
    
    func getFileURL() -> NSURL {
        let pathToRecording = getCacheDirectory().URLByAppendingPathComponent(newFileName)
        return pathToRecording
    }
    
    func setupRecorder() {
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setActive(true)
        } catch {
            print(error)
        }
        
        let recordSettings = [
            AVSampleRateKey : NSNumber(float: Float(44100.0)),
            AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleLossless)),
            AVNumberOfChannelsKey : NSNumber(int: 1),
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue)),
            AVEncoderBitRateKey : NSNumber(int: Int32(320000))
        ]
        
        var error : NSError?
        
        do {
            soundRecorder = try AVAudioRecorder(URL: newFileURL(), settings: recordSettings)
        } catch let error1 as NSError {
            error = error1
            soundRecorder = nil
        }
        
        if error != nil {
            NSLog("Something went wrong")
        } else {
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }
        
    }
    
    func clearSaveNotification() {
        savedNotification.hidden = true
    }
    
    @IBAction func handleRecOk(sender: UIButton) {
        let recOkDisable = UIImage(named: "rec_ok_disabled.png")
        soundRecorder.stop()
        savedNotification.hidden = false
        plyBtn.enabled = true
        recInSession = false
        recPaused = false
        recOkBtn.setImage(recOkDisable, forState: .Normal)
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("clearSaveNotification"), userInfo: nil, repeats: false)
    }
    
    @IBAction func handleRec(sender: UIButton) {
        let recStrtImg = UIImage(named: "rec_start_icon.png")
        let recPauseImg = UIImage(named: "rec_pause_icon.png")
        let recOkDisable = UIImage(named: "rec_ok_disabled.png")
        let recOkEnabled = UIImage(named: "rec_ok_enabled.png")
        print("handle rec action")
//        if !recInSession {
//            recBtnNew.setImage(recPauseImg, forState: .Normal)
//            setupRecorder()
//            soundRecorder.record()
//            recInSession = true
//        } else {
//            recBtnNew.setImage(recStrtImg, forState: .Normal)
//            soundRecorder.pause()
//        }
        
        if recInSession == false && recPaused == false {
            print("new rec")
            recBtnNew.setImage(recPauseImg, forState: .Normal)
            setupRecorder()
            soundRecorder.record()
            recInSession = true
            plyBtn.enabled = false
        } else if recInSession == true && recPaused == false {
            print("rec paused")
            soundRecorder.pause()
            recPaused = true
            recOkBtn.setImage(recOkEnabled, forState: .Normal)
            recBtnNew.setImage(recStrtImg, forState: .Normal)
        } else {
            print("rec restarted")
            soundRecorder.record()
            recPaused = false
            recOkBtn.setImage(recOkDisable, forState: .Normal)
            recBtnNew.setImage(recPauseImg, forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedNotification.hidden = true
        recImgView.image = slctdImg
        recImgView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
