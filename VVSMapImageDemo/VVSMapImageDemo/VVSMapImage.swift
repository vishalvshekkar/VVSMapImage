//
//  VVSMapImage.swift
//  VVSMapImageDemo
//
//  Created by Vishal V Shekkar on 28/02/16.
//  Copyright © 2016 Vishal. All rights reserved.
//

import UIKit
import MapKit

class VVSMapImage
{
    var snapShotter: MKMapSnapshotter!
    let VVSMapImageQueue = dispatch_queue_create(NSBundle.mainBundle().bundleIdentifier! + "VVSMapImageQueue", DISPATCH_QUEUE_CONCURRENT)
    
    /*Use the following method to get an image that is created using 'MKMapSnapshotter'. This class is optimized to use with tableviews. That is why the callbacksa provide the indexPath that you passw hile calling the method, which allows you to check if the row that the callback responds with is visible or not. I would suggest the use of an image caching library with this for best results.
    
    I have added an example of how you would cache if SDImageCache is used [Within comments in the following method]. Don't uncomment that code if you don't have SDImageCache. Implement similar functionality in the following places in your own manner. The 'identifier' parameter accepted by the function is the identifier that should be used for the cache, as well. Feel free to delete the commented code if you don't need caching.
    
    coordinates - coordinates on the map that needs to be on the center of the image.
    xrRadii - This is used to define the region or the zoom level of the map. The smaller the radius, the more zoomed in the image would be. Unit - Kilometers
    imageSize - The bounds of the image in pixels.
    identifier - should be unique for every image. Used for caching, if implemented.
    indexPath - Used to identify which row's callback responded [as this is done asynchronously] when used in a tableview.
    
    image - The image that you require. It can be nil for various reasons including invalid coordinates, lack of network connection and so on.
    error - An error object if an error occurs at any point.
    */
    
    
    func getMapPhotoForIdentifier(coordinates: CLLocationCoordinate2D, xyRadii: Double, imageSize: CGSize, identifier: String?, indexPath: NSIndexPath?, completion: (identifier: String?, indexPath: NSIndexPath?, image: UIImage?, error: NSError?) -> ())
    {
//        if let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(identifier)
//        {
//            completion(identifier: identifier, indexPath: indexPath, image: image, error: nil)
//        }
//        else
//        {
            let region = MKCoordinateRegion.regionWithDistances(xyRadii, yDistance: xyRadii, center: coordinates)
            let snapShotterOptions = MKMapSnapshotOptions()
            snapShotterOptions.size = imageSize
            snapShotterOptions.region = region
            snapShotterOptions.mapType = MKMapType.Standard
            snapShotter = MKMapSnapshotter(options: snapShotterOptions)
            snapShotter?.startWithQueue(VVSMapImageQueue, completionHandler: { [weak self] (snapShot, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    if let image = snapShot?.image
//                    {
//                        SDImageCache.sharedImageCache().storeImage(image, forKey: identifier)
//                    }
                    completion(identifier: identifier, indexPath: indexPath, image: snapShot?.image, error: error)
                    self?.snapShotter = nil
                })
            })
//        }
    }
}

extension MKCoordinateRegion
{
    static func regionWithDistances(xDistance: Double, yDistance: Double, center: CLLocationCoordinate2D) -> MKCoordinateRegion
    {
        let kilometersPerDegree: Double = 111.0
        let latDelta = xDistance/kilometersPerDegree
        let lonDelta = yDistance/(kilometersPerDegree*cos(center.latitude * M_PI / 180.0))
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        return MKCoordinateRegion(center: center, span: span)
    }
}