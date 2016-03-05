//
//  ViewController.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/2/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit

    var slctdImg:UIImage!

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgPckBtn: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var toRecViewBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
//    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgVw.contentMode = .ScaleAspectFit
            imgVw.image = pickedImage
            slctdImg = pickedImage
//            userDefaults.setObject(slctdImg, forKey: "micFlagImage")
        }
        dismissViewControllerAnimated(true, completion: nil)
        toRecViewBtn.enabled = true
    }
    
    @IBAction func imgPckBtnClck(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        toRecViewBtn.enabled = false
//        if (userDefaults.objectForKey("micFlagImage") != nil) {
//            print("image exists")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

