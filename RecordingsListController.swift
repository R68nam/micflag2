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

    @IBOutlet var recordingsListTable: UITableView!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var soundPlayer : AVAudioPlayer!
    var recordings : [String]!
    var selectedRecording : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordings = userDefaults.objectForKey("micFlagRecordings") as? [String]
        return (recordings?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = recordings[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            self.recordings.removeAtIndex(indexPath.row)
            self.userDefaults.setObject(self.recordings, forKey: "micFlagRecordings")
            self.recordingsListTable.reloadData()
        }
        delete.backgroundColor = UIColor.redColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            let fileToShare = self.recordings[indexPath.row]
            let pathToFileToShare = self.getCacheDirectory().URLByAppendingPathComponent(fileToShare)
//            let fileData = NSData(contentsOfURL: pathToFileToShare)
//            let sendData = fileData
            let activityView = UIActivityViewController(activityItems: [pathToFileToShare], applicationActivities: nil)
            self.presentViewController(activityView, animated: true, completion: nil)
        }
        share.backgroundColor = UIColor.blueColor()
                
        return [share, delete]
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
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 1.0
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(recordings[indexPath.row])
        selectedRecording = recordings[indexPath.row]
        preparePlayer()
        soundPlayer.play()
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
