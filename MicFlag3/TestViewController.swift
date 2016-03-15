//
//  TestViewController.swift
//  MicFlag3
//
//  Created by Nam Nguyen on 3/15/16.
//  Copyright © 2016 Nam Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class TestViewController: UIViewController {

    @IBOutlet var testUiView: UIView!
    var imageView : UIImageView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: slctdImg.size.width, height: slctdImg.size.height)
        let aspectRect = AVMakeRectWithAspectRatioInsideRect(size, testUiView.bounds)
        print(aspectRect.size.height)
        print(aspectRect.size.width)
        imageView = UIImageView(frame: CGRectMake(0, 0, aspectRect.size.width, aspectRect.size.height))
        imageView?.image = slctdImg
        imageView?.contentMode = .ScaleAspectFit
        imageView?.clipsToBounds = true
        self.view.addSubview(imageView!)
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
