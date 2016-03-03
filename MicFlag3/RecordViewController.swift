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
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths[0]
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
        
        let path = getCacheDirectory().stringByAppendingString(newFileName)
        
        print(path)
        
        let filePath = NSURL(fileURLWithPath: path)
        saveFileReference()
        return filePath
    }
    
    func getFileURL() -> NSURL {
        let pathToRecording = getCacheDirectory().stringByAppendingString(newFileName)
        let filePathToRecording = NSURL(fileURLWithPath: pathToRecording)
        return filePathToRecording
    }
    
    func setupRecorder() {
        let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
            AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
            AVNumberOfChannelsKey : NSNumber(int: 1),
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Max.rawValue))]
        
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
    
    func preparePlayer() {
        var error: NSError?
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
        } catch let error1 as NSError {
            error = error1
            soundPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
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
                    setupRecorder()
                }

    }
    
    @IBAction func plyActn(sender: UIBarButtonItem) {
        if sender.title == "Play" {
                        recBtn.enabled = false
                        sender.title = "Stop"
                        preparePlayer()
                        soundPlayer.play()
                    } else {
                        soundPlayer.stop()
                        sender.title = "Play"
                        recBtn.enabled = true
                    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recImgView.image = slctdImg
        setupRecorder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
