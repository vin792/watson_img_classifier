//
//  ImageCapturedViewController.swift
//  HotdogNotHotdog
//
//  Created by Jordan Russell Weatherford on 5/18/17.
//  Copyright © 2017 Nicole Zurita. All rights reserved.
//

import UIKit

class ImageCapturedViewController: UIViewController {
    
    @IBOutlet weak var capturedImageView: UIImageView!
    
    var capturedImage : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImageView.image = capturedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
