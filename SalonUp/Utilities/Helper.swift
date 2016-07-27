//
//  Helper.swift
//  SalonUp
//
//  Created by Anagha Ajith on 23/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import UIKit

class Helper {
    
    class func stringForDate(date:NSDate?, format:String) -> String {
        
        guard let date = date else {
            return kEmptyString
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.stringFromDate(date)
        return dateString;
    }
    
    
}
