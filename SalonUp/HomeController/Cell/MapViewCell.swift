//
//  MapViewCell.swift
//  SalonUp
//
//  Created by Anagha Ajith on 24/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewCell: UITableViewCell, GMSMapViewDelegate {
    
    @IBOutlet weak var viewMap: GMSMapView!
    let locationManager = CLLocationManager()
    var coordinates = CLLocationCoordinate2D()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateMapView(dictionary : [NSDictionary]) {
        
        var location = CLLocationCoordinate2D()
        var bounds = GMSCoordinateBounds()
        for i in 0..<dictionary.count {
            location.latitude = dictionary[i].valueForKey("lat")!.doubleValue
            location.longitude = dictionary[i].valueForKey("lng")!.doubleValue
            let  position = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            let marker1 = GMSMarker(position: position)
            bounds = bounds.includingCoordinate(marker1.position)
          
            if i == 0 {
                marker1.map = nil
            }
            else {
                marker1.title = dictionary[i].valueForKey("string") as? String
                marker1.map = viewMap
            }
            self.viewMap.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding:  30.0))
        }
    }
}

//MARK: - Extensions
extension MapViewCell: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap.myLocationEnabled = true
            viewMap.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            
        }
    }
}
