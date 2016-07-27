//
//  SalonDetails.swift
//  SalonUp
//
//  Created by Anagha Ajith on 20/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import Foundation

class SalonDetails : NSObject {
    
    var location : NSDictionary?
    var name : String?
    var place_id : String?
    var address : String?
    var rating : String?
    var phoneNo : String?
    var area : String?
    var reviews : [NSDictionary]?
    var open_now : Bool?
    var distance : String?
    var timings : NSArray?
    var photos : [NSDictionary]?
}