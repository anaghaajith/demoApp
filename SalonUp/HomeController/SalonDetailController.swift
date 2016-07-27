//
//  SalonDetailController.swift
//  SalonUp
//
//  Created by Anagha Ajith on 23/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
class SalonDetailController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, CallButtonPressedDelegate {
    
    var locationManager = CLLocationManager()
    var salonDetails = SalonDetails()
    var currentDay = Int()
    var currentCoordinates = CLLocationCoordinate2D()
    var dictionary = [NSDictionary]()
    var images = [UIImage]()
    var attributionTextView = UITextView()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if let coordinate = locationManager.location?.coordinate {
            currentCoordinates = coordinate
            var dict = [String : AnyObject]()
            dict["lat"] = coordinate.latitude
            dict["lng"] = coordinate.longitude
            dict["string"] = "Current Location"
            dictionary.append(dict)
        }
        addLocation()
        tableView.registerNib(UINib(nibName: "SalonDetailCell", bundle: nil), forCellReuseIdentifier: "SalonDetailCell")
        tableView.registerNib(UINib(nibName: "MapViewCell", bundle: nil), forCellReuseIdentifier: "MapViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Delegate function definition
    func callFailed() {
        let alertController = UIAlertController.init(title: "SORRY!", message: "Number not available", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addLocation(){
        if let loc = salonDetails.location as NSDictionary? {
            var dict = [String : AnyObject]()
            dict["lat"] = loc.valueForKey("lat")
            dict["lng"] = loc.valueForKey("lng")
            dict["string"] = salonDetails.name
            dictionary.append(dict)
        }
    }
    
//MARK: - Function to search photos using placeId ; Not implemented now.

//    func loadFirstPhotoForPlace(placeID: String) {
//        GMSPlacesClient.sharedClient().lookUpPhotosForPlaceID(placeID) { (photos, error) -> Void in
//            if let error = error {
//                // TODO: handle the error.
//                print("Error: \(error.description)")
//            } else {
//                
//                if let first = photos?.results{
//                    for i in first {
//                        self.loadImageForMetadata(i)
//                    }
//                }
//                
//                if let firstPhoto = photos?.results.first {
//                    self.loadImageForMetadata(firstPhoto)
//                }
//            }
//        }
//    }
//
//    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
//        GMSPlacesClient.sharedClient()
//            .loadPlacePhoto(photoMetadata, constrainedToSize: backgroundImageView.bounds.size,
//                            scale: self.backgroundImageView.window!.screen.scale) { (photo, error) -> Void in
//                                if let error = error {
//                                    // TODO: handle the error.
//                                    print("Error: \(error.description)")
//                                } else {
//                                    self.backgroundImageView.image = photo ?? AssetImage.logo.image
//                                    self.backgroundImageView.contentMode = .ScaleAspectFill
//                                    self.attributionTextView.attributedText = photoMetadata.attributions;
//                                    
//                                }
//        }
//    }
}

//MARK:- Extensions
extension SalonDetailController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        else {
            if let count = salonDetails.reviews?.count as Int? {
                return count
            }
            else {
                return 0
            }
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(SalonDetailCell), forIndexPath: indexPath) as! SalonDetailCell
            cell.createCell(salonDetails, day: currentDay)
            return cell
        }
            
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(MapViewCell), forIndexPath: indexPath) as! MapViewCell
            
            cell.viewMap.delegate = self
            cell.locationManager.delegate = self
            cell.viewMap.myLocationEnabled = true
            cell.locationManager.startUpdatingLocation()
            cell.viewMap.userInteractionEnabled = false
            cell.updateMapView(dictionary)
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ReviewCell), forIndexPath: indexPath) as! ReviewCell
            if let reviews = salonDetails.reviews as [NSDictionary]? {
                cell.createCell(reviews[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 200
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 126
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }
        else {
            return 25
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 25))
        let sectionLabel = UILabel(frame: CGRect(x: 10, y: 0, width: sectionHeader.frame.size.width , height: 25))
        sectionHeader.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        sectionLabel.textColor = UIColor.lightGrayColor()
        sectionLabel.font = UIFont.systemFontOfSize(13)
        sectionLabel.text = "Reviews"
        sectionHeader.addSubview(sectionLabel)
        return sectionHeader
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            var customURL = String()
            //Call given phone number
            if let location = salonDetails.location as NSDictionary? {
                if let lat = location.valueForKey("lat") as? Double, let long = location.valueForKey("lng") as? Double{
                    customURL = "comgooglemaps://?daddr=\(lat),\(long)&directionsmode=driving&zoom=12"
                }
                else {
                    customURL = "comgooglemaps://"
                }
            }
                
            else {
                customURL = "comgooglemaps://"
            }
            
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: customURL)!) {
                UIApplication.sharedApplication().openURL(NSURL(string: customURL)!)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Google maps not installed", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated:true, completion: nil)
            }
        }
    }
}
