//
//  ViewController.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/2/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

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
//    @IBOutlet var imgVw: UIImageView!
    @IBOutlet weak var toRecViewBtn: UIButton!
    @IBOutlet var imgReuse: UILabel!
    
    var imageView : UIImageView?
    var imagePicker = UIImagePickerController()
    var imagePicked : Bool!
    var data : NSData!
    let deviceScreenSize : CGRect = UIScreen.mainScreen().bounds
    
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
    
    let newUiView : UIView = UIView()
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        print(image)
        if image == nil {
            imgReuse.hidden = true
            print("missing image at: \(path)")
        } else {
            imgReuse.hidden = false
            slctdImg = image
            newUiView.translatesAutoresizingMaskIntoConstraints = false
            newUiView.frame = CGRectMake(deviceScreenSize.width * 0.27, deviceScreenSize.height * 0.53, deviceScreenSize.width * 0.45, deviceScreenSize.height * 0.45)
            newUiView.backgroundColor = UIColor.blackColor()
            newUiView.bottomAnchor
            self.view.addSubview(newUiView)
            let size = CGSize(width: slctdImg.size.width, height: slctdImg.size.height)
            let aspectRect = AVMakeRectWithAspectRatioInsideRect(size, newUiView.bounds)
            imageView = UIImageView(frame: CGRectMake(0, 0, aspectRect.size.width, aspectRect.size.height))
            imageView?.image = slctdImg
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
            imageView!.userInteractionEnabled = true
            imageView!.addGestureRecognizer(tapGestureRecognizer)
            newUiView.addSubview(imageView!)
            print("Loading image from path: \(path)")
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
//        dispatch_async(dispatch_get_main_queue()) {
//            self.performSegueWithIdentifier("recViewSegue", sender: true)
//        }
        if let recView = storyboard!.instantiateViewControllerWithIdentifier("RecordViewController") as? RecordViewController {
            recView.transitioningDelegate = self
            presentViewController(recView, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView!.contentMode = .ScaleAspectFit
            imageView!.image = pickedImage
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
    
    let container = UILayoutGuide()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        loadImageFromPath(imagePath)
        imgPckBtn.layer.borderWidth = 1
        imgPckBtn.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = PresentRecViewAnimator()
        animator.originFrame = newUiView.superview!.convertRect(newUiView.frame, toView: nil)
        return animator
    }
}
