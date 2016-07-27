//
//  SalonController.swift
//  SalonUp
//
//  Created by Anagha Ajith on 18/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import CoreLocation


enum Days : Int {
    
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}


class SalonController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var latLongInString = String()
    var versionNumber = String()
    var salonDetails = [SalonDetails]()
    var currentLocation : CLLocation?
    var isPressed : Bool = false
    var subLocality = String()
    var currentDay = Int()
    var dictionary = [NSDictionary]()
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        tableView.tableFooterView = UIView(frame : CGRectZero)
        createNavBar()
        
        if let coordinate = locationManager.location?.coordinate {
            getLatLongInString(Double(coordinate.latitude), long: Double(coordinate.longitude))
            currentLocation = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        googleMapPlaceIdSearch()
        tableView.backgroundColor = UIColor.themeColor()
        getDayIndex()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function to get current day index
    func getDayIndex() {
        let currentDayInString = Helper.stringForDate(NSDate(), format: "EEEE")
        switch currentDayInString {
        case "Monday" : currentDay = Days.Monday.rawValue
            break
        case "Tuesday" : currentDay = Days.Tuesday.rawValue
            break
        case "Wednesday" : currentDay = Days.Wednesday.rawValue
            break
        case "Thursday" : currentDay = Days.Thursday.rawValue
            break
        case "Friday" : currentDay = Days.Friday.rawValue
            break
        case "Saturday" : currentDay = Days.Saturday.rawValue
            break
        case "Sunday" : currentDay = Days.Sunday.rawValue
            break
        default : currentDay = 10
        }
    }
    
    //MARK: - Formatting navigation bar
    func createNavBar() {
        self.navigationController?.setupNavigationBar()
        navigationController?.navigationBar.topItem?.title = "Salons"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: AssetImage.sideNav.image, style: .Plain, target: self, action: #selector(SalonController.sideNavPressed))
    }
    
    func sideNavPressed() {
        let alertController = UIAlertController.init(title: "SORRY!!", message: "Nothing here yet!", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getLatLongInString(lat: Double, long : Double){
        var array = [String]()
        array.append(String(lat))
        array.append(String(long))
        latLongInString = array.joinWithSeparator(",")
        
    }
    
    //MARK:- Service calls to get placeId and search salons
    func googleMapPlaceIdSearch(){
        LoadingController.instance.showLoadingWithOverlayForSender(self, cancel: true)
        Alamofire.request(Router.GetGoogleData(radius: "1000", query: "beauty_salon", ll: self.latLongInString)).responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                print("Success with JSON1")
                
                guard let jsonData = JSON as? NSDictionary else{
                    print("Incorrect JSON from server : \(JSON)")
                    return
                }
                LoadingController.instance.hideLoadingView()
                var isSuccess = false
                if let response = jsonData.valueForKey("results") as? [NSDictionary]{
                    if  let array = response as NSArray? {
                        for item in array as! [NSDictionary] {
                            if let place = item.valueForKey("place_id") as? String {
                                self.googleMapPlaceSearch(place)
                                isSuccess = true
                            }
                        }
                    }
                }
                
                if isSuccess == false {
                    let alertController = UIAlertController.init(title: kEmptyString, message: "Cannot retrieve data at the moment. Request quota exceeded.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                var message = error.localizedDescription
                if error.code == 403 {
                    message = "Session Expired"
                    NSLog(message)
                }
                let alertController = UIAlertController.init(title: kEmptyString, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func googleMapPlaceSearch(placeId : String){
        LoadingController.instance.showLoadingWithOverlayForSender(self, cancel: true)
        Alamofire.request(Router.GetPlaces(placeId : placeId)).responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                print("Success with JSON2")
                
                guard let jsonData = JSON as? NSDictionary else{
                    print("Incorrect JSON from server : \(JSON)")
                    return
                }
                LoadingController.instance.hideLoadingView()
                if let response = jsonData.valueForKey("result") as? NSDictionary{
                    if let salonDetailsParsed = Parser.getDataFromDict(response) {
                        let updatedDetails = self.calculateDistance(salonDetailsParsed)
                        self.salonDetails.append(updatedDetails)
                    }
                }
                
                self.tableView.reloadData()
                
                if self.salonDetails.isEmpty {
                    let alertController = UIAlertController.init(title: kEmptyString, message: "Cannot retrieve data at the moment. Request quota exceeded.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                var message = error.localizedDescription
                if error.code == 403 {
                    message = "Session Expired"
                    NSLog(message)
                }
                let alertController = UIAlertController.init(title: kEmptyString, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - function to calculate distance between current location and place
    func calculateDistance(data : SalonDetails) -> SalonDetails {
        if let location = data.valueForKey("location") as? NSDictionary{
            if let lat = location.valueForKey("lat")?.doubleValue,
                let long = location.valueForKey("lng")?.doubleValue {
                let coordinates = CLLocation(latitude: lat, longitude: long)
                
                if let distanceInMeters = currentLocation?.distanceFromLocation(coordinates) {
                    if distanceInMeters < 1000 {
                        let dist = Int(distanceInMeters)
                        data.distance = String(dist) + "m"
                    }
                    else {
                        let test : Double = 654.921794868649851872458175
                        test.roundToPlaces(2)
                        distanceInMeters.roundToPlaces(1)
                        data.distance = String(distanceInMeters/1000) + "km"
                    }
                    return data
                }
            }
        }
        return data
    }
}

//MARK: - Extensions
extension SalonController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salonDetails.count ?? 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(SalonCell), forIndexPath: indexPath) as! SalonCell
        cell.createCell(salonDetails[indexPath.row] , index : indexPath.row)
        cell.backgroundColor = UIColor.themeColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let salonDetailController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(SalonDetailController)) as! SalonDetailController
        salonDetailController.currentDay = currentDay
        
        salonDetailController.salonDetails = salonDetails[indexPath.row]
        navigationController?.pushViewController(salonDetailController, animated: true)
    }
}


