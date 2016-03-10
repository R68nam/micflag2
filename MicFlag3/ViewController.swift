//
//  ViewController.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/2/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit

    var slctdImg : UIImage!

    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }

    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgPckBtn: UIButton!
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet weak var toRecViewBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagePicked : Bool!
    var data : NSData!
    
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        print(image)
        if image == nil {
            
            print("missing image at: \(path)")
        } else {
            print("Loading image from path: \(path)")
            print(image!.imageOrientation)
            print("width: \(image!.size.width)")
            print("height: \(image!.size.height)")
            imgVw.image = image
            slctdImg = image
        }
        return image
        
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        let pngImageData = UIImageJPEGRepresentation(image, 1.0)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    
    let imagePath = fileInDocumentsDirectory("micFlagImg.png")
    
    func recViewSegue() {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("recViewSegue", sender: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgVw.contentMode = .ScaleAspectFit
            print(pickedImage.imageOrientation)
            imgVw.image = pickedImage
            slctdImg = pickedImage
            saveImage(slctdImg, path: imagePath)
        }
        dismissViewControllerAnimated(true) { () -> Void in
            self.recViewSegue()
        }
    }
    
    @IBAction func imgPckBtnClck(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imageTapped(img: AnyObject) {
        recViewSegue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        loadImageFromPath(imagePath)
        let imageView = imgVw
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imgPckBtn.layer.borderWidth = 1
        imgPckBtn.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

