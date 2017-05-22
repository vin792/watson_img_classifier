//
//  ImageCapturedViewController.swift
//  HotdogNotHotdog
//
//  Created by Jordan Russell Weatherford on 5/18/17.
//  Copyright © 2017 Nicole Zurita. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ImageCapturedViewController: UIViewController {
    
    //Watson Info
    let apiKey = "5a08b9cf8099a1678a467143b2b062ee9e617ad4"
    let version = "2017-05-18"
    var visualRecognition : VisualRecognition?
    
    //Controller variables
    var classifiers: Array<Classification>?
    var labels = Array<UILabel>()
    var capturedImage : UIImage?
    var dataImage: Data?
    
    //IB outlets
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var newCaptureButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    //IB Actions
    @IBAction func newCaptureButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }

    //View did load functions
    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImageView.image = capturedImage
        newCaptureButton.layer.cornerRadius = 15
        newCaptureButton.clipsToBounds = true
        visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        callWatson()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Call Watson api
    func callWatson() {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent("tmp.jpg")
        try! dataImage?.write(to: imageURL)
        let failure = { (error: Error) in print(error) }
        
        visualRecognition?.classify(imageFile: imageURL, failure: failure){ClassifiedImages in
            self.classifiers = ClassifiedImages.images[0].classifiers[0].classes
            for classifier in self.classifiers! {
                let newLabel = UILabel()
                newLabel.textColor = UIColor.white
                newLabel.textAlignment = .center
                newLabel.text = "\(classifier.classification), \(classifier.score)"
                self.labels.append(newLabel)
            }
            self.createLabel()
        }
    }
    
    //Add Watson classifier UIlabels to view
    func createLabel() {
        DispatchQueue.main.async {
            for label in self.labels {
                self.stackView.addArrangedSubview(label)
            }
        }
    }
}
