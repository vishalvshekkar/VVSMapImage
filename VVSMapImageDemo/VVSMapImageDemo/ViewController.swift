//
//  ViewController.swift
//  VVSMapImageDemo
//
//  Created by Vishal V Shekkar on 28/02/16.
//  Copyright © 2016 Vishal. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    let mapImage = VVSMapImage()
    var startTime: NSTimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Uncomment only one of the following at a time and see different images.
        
//        let coordinates = CLLocationCoordinate2D(latitude: 48.8582, longitude: 2.2945) //Eiffel Tower
//        let coordinates = CLLocationCoordinate2D(latitude: 27.1750, longitude: 78.0419) //Taj Mahal
        let coordinates = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0444) //Statue of Liberty
        
        startTime = NSDate().timeIntervalSince1970
        mapImage.getMapPhotoForIdentifier(coordinates, xyRadii: 5, imageSize: CGSize(width: 250, height: 250), identifier: nil, indexPath: nil) { [unowned self] (identifier, indexPath, image, error) -> () in
            self.imageView.image = image
            if let _ = image, let startTime = self.startTime {
                self.timeLabel.text = "\(Double(Int((NSDate().timeIntervalSince1970 - startTime)*10))/10.0) Seconds"
            }
        }
    }



}

