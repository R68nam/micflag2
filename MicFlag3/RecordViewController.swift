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

    @IBOutlet var recImgViewContainer: UIView!
    @IBOutlet weak var plyBtn: UIBarButtonItem!
    @IBOutlet var recBtnNew: UIButton!
    @IBOutlet var recOkBtn: UIButton!
    @IBOutlet var savedNotification: UILabel!
    @IBOutlet var toolbar: UIToolbar!
    
    var imageView : UIImageView?
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
    
    @IBOutlet weak var okBtnHeightConstraint : NSLayoutConstraint!
    func btnOkAnimateUp() {
        okBtnHeightConstraint.constant = 83.0
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func btnOkAnimateDown() {
        okBtnHeightConstraint.constant = -100.0
        UIView.animateWithDuration(0.75, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func handleRecOk(sender: UIButton) {
        let recOkDisable = UIImage(named: "rec_ok_disabled.png")
        soundRecorder.stop()
        savedNotification.hidden = false
        plyBtn.enabled = true
        recInSession = false
        recPaused = false
        recOkBtn.setImage(recOkDisable, forState: .Normal)
        btnOkAnimateDown()
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("clearSaveNotification"), userInfo: nil, repeats: false)
    }
    
    @IBAction func handleRec(sender: UIButton) {
        let recStrtImg = UIImage(named: "rec_start_icon.png")
        let recPauseImg = UIImage(named: "rec_pause_icon.png")
        let recOkDisable = UIImage(named: "rec_ok_disabled.png")
        let recOkEnabled = UIImage(named: "rec_ok_enabled.png")
        print("handle rec action")

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
            btnOkAnimateUp()
        } else {
            print("rec restarted")
            soundRecorder.record()
            recPaused = false
            recOkBtn.setImage(recOkDisable, forState: .Normal)
            recBtnNew.setImage(recPauseImg, forState: .Normal)
            btnOkAnimateDown()
        }
    }
    
    @IBOutlet weak var recBtnHeightConstraint : NSLayoutConstraint!
    @IBOutlet var toolbarConstraint : NSLayoutConstraint!
    
    func btnLoadAnimate() {
        recBtnHeightConstraint.constant = 73.0
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func recBtnHide() {
        recBtnHeightConstraint.constant = -100
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func hideToolBar() {
//        toolbar.hidden = true
        toolbarConstraint.constant = 100
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func returnToImgSelect(sender: UIBarButtonItem) {
        recBtnHide()
        hideToolBar()
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedNotification.hidden = true
        let size = CGSize(width: slctdImg.size.width, height: slctdImg.size.height)
        let aspectRect = AVMakeRectWithAspectRatioInsideRect(size, UIScreen.mainScreen().bounds)
        print(aspectRect.size.height)
        print(aspectRect.size.width)
        print(recImgViewContainer.bounds.width)
        imageView = UIImageView(frame: CGRectMake(0, 0, aspectRect.size.width, aspectRect.size.height))
        imageView?.image = slctdImg
        recBtnNew.layer.zPosition = 1
        recOkBtn.layer.zPosition = 1
        recBtnHeightConstraint.constant = -100.0
        okBtnHeightConstraint.constant = -100.0
        UIView.animateWithDuration(1.0, delay: 0, options: [.CurveEaseOut], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        savedNotification.layer.zPosition = 1
        self.view.addSubview(imageView!)
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.5), target: self, selector: "btnLoadAnimate", userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
