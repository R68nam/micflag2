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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            recordings.removeAtIndex(indexPath.row)
            userDefaults.setObject(recordings, forKey: "micFlagRecordings")
            recordingsListTable.reloadData()
        }
        
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
