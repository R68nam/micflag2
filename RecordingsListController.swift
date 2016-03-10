//
//  RecordingsListController.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/4/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingsListController: UIViewController, UITableViewDelegate, AVAudioPlayerDelegate {

    @IBOutlet var recordingsListTable : UITableView!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var soundPlayer : AVAudioPlayer!
    var recordings : [String]!
    var selectedRecording : String!
    var selectedTableRow : UITableViewCell!
    var isPlaying : Bool!
    var isTableCellEditing : Bool = false
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isPlaying = false
    }
    
    @IBAction func editTableRows(sender: AnyObject) {
        if !isTableCellEditing {
            recordingsListTable.editing = true
            isTableCellEditing = true
        } else {
            recordingsListTable.editing = false
            isTableCellEditing = false
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordings = userDefaults.objectForKey("micFlagRecordings") as? [String]
        if recordings == nil {
            return 0
        } else {
            recordings = recordings.reverse()
            return (recordings?.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let fileString = recordings[indexPath.row]
        let fileStringArray = fileString.componentsSeparatedByString("_")
        let recDateComponents = NSDateComponents()
        recDateComponents.year = Int(fileStringArray[3])!
        recDateComponents.month = Int(fileStringArray[1])!
        recDateComponents.day = Int(fileStringArray[2])!
        recDateComponents.hour = Int(fileStringArray[4])!
        recDateComponents.minute = Int(fileStringArray[5])!
        recDateComponents.second = Int(fileStringArray[6].componentsSeparatedByString(".")[0])!
        let recDate = NSCalendar.currentCalendar().dateFromComponents(recDateComponents)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .MediumStyle
        let finalDateString = dateFormatter.stringFromDate(recDate!)
        cell.textLabel?.text = finalDateString
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            let filePathToDelete = self.getCacheDirectory().URLByAppendingPathComponent(self.recordings[indexPath.row])
            do {
                try NSFileManager.defaultManager().removeItemAtURL(filePathToDelete)
                print("file removed from directory")
            } catch {
                print("error when trying to remove file")
            }
            self.recordings.removeAtIndex(indexPath.row)
            self.userDefaults.setObject(self.recordings, forKey: "micFlagRecordings")
            self.recordingsListTable.reloadData()
        }
        delete.backgroundColor = UIColor.redColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            let fileToShare = self.recordings[indexPath.row]
            let pathToFileToShare = self.getCacheDirectory().URLByAppendingPathComponent(fileToShare)
            let activityView = UIActivityViewController(activityItems: [pathToFileToShare], applicationActivities: nil)
            self.presentViewController(activityView, animated: true, completion: nil)
        }
        share.backgroundColor = UIColor.blueColor()
                
        return [delete, share]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func getCacheDirectory() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    func getFileURL() -> NSURL {
        let pathToRecording = getCacheDirectory().URLByAppendingPathComponent(selectedRecording)
        return pathToRecording
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
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                soundPlayer.delegate = self
                print(soundPlayer.duration)
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 1.0
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(recordings[indexPath.row])
        if isPlaying == false {
            isPlaying = true
            selectedRecording = recordings[indexPath.row]
            selectedTableRow = recordingsListTable.cellForRowAtIndexPath(indexPath)!
            selectedTableRow.contentView.backgroundColor = UIColor.greenColor()
            preparePlayer()
            soundPlayer.play()
        } else {
            isPlaying = false
            soundPlayer.stop()
            selectedTableRow.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("audio done playing")
        selectedTableRow.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
