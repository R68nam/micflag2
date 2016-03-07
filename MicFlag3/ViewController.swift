//
//  ViewController.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/2/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit

    var slctdImg:UIImage!

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
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var toRecViewBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagePicked : Bool!
    var data : NSData!
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        } else {
            print("Loading image from path: \(path)")
            imgVw.image = image
            slctdImg = image
            toRecViewBtn.enabled = true
        }
        return image
        
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    
    let imagePath = fileInDocumentsDirectory("micFlagImg.png")
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgVw.contentMode = .ScaleAspectFit
            imgVw.image = pickedImage
            slctdImg = pickedImage
            saveImage(slctdImg, path: imagePath)
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
        loadImageFromPath(imagePath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

