//
//  Parser.swift
//  SalonUp
//
//  Created by Anagha Ajith on 15/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import Foundation
import Alamofire

class Parser {
    
    
    
    
    
    class func getDataFromDict(dict : NSDictionary) -> SalonDetails? {
        guard let data = dict as NSDictionary! else {
            return nil
        }
        let salonDetails = SalonDetails()
//
        if let name = data["name"] as? String {
            salonDetails.name = name
        }
        if let place_id = data["place_id"] as? String {
            salonDetails.place_id = place_id
        }
        
        if let area = data.valueForKeyPath("address_components") as? [NSDictionary]{
            if let items = area as NSArray? {
                for item in items as! [NSDictionary] {
                    if let areaCode = item.valueForKey("types") as? [String] {
                        if areaCode.contains("sublocality_level_2") {
                            salonDetails.area = item.valueForKey("short_name") as? String
                            break
                        }
                        else if areaCode.contains("sublocality_level_1") {
                               salonDetails.area = item.valueForKey("short_name") as? String
                            break
                        }
                        else {
                             salonDetails.area = "Bengaluru"
                            
                        }
                    
                    }
                }
                
                
            }
            
            
        }
        
        if let phoneNo = data.valueForKey("international_phone_number") as? String {
            salonDetails.phoneNo = phoneNo
        }
        
        if let address = data["formatted_address"] as? String {
            salonDetails.address = address
        }
        if let rating = data["rating"] as? Float {
            salonDetails.rating = String(rating)
        }

        if let location = data.valueForKeyPath("geometry.location") as? NSDictionary {
            salonDetails.location = location
        }
        
        if let reviews = data.valueForKey("reviews") as? [NSDictionary] {
                salonDetails.reviews = reviews

        }
        
        if let timing = data.valueForKey("opening_hours") as? NSDictionary {
            if let open = timing.valueForKey("open_now") as? Bool {
                salonDetails.open_now = open
            }
            
            if let timings = timing.valueForKey("weekday_text") as? NSArray {
                salonDetails.timings = timings
            }
        }
        
        if let photos = data.valueForKey("photos") as? [NSDictionary] {
//            if let items = photos as NSArray? {
//                for item in items as! [NSDictionary] {
//                    if let photoRef = item.valueForKey("photo_reference") as? String {
//                      
//                    }
//                }
//            }
            salonDetails.photos = photos
        }
        
        return salonDetails
    }
    
    
    
    
}