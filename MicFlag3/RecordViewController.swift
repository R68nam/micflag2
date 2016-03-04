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

    @IBOutlet weak var recImgView: UIImageView!
    @IBOutlet weak var recBtn: UIBarButtonItem!
    @IBOutlet weak var plyBtn: UIBarButtonItem!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    var fileName = "micFlagRecording"
    var newFileName = ""
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
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
    
    @IBAction func recActn(sender: UIBarButtonItem) {
        print("record started")
        if sender.title == "Record" {
            soundRecorder.record()
            recBtn.title = "Stop"
        } else {
            soundRecorder.stop()
            recBtn.title = "Record"
            plyBtn.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recImgView.image = slctdImg
        setupRecorder()
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
