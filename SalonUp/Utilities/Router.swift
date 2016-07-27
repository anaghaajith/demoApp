//
//  Router.swift
//  SalonUp
//
//  Created by Anagha Ajith on 14/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import Foundation
import Alamofire


enum Router : URLRequestConvertible {
    static let baseURLString = "https://maps.googleapis.com/maps/api/place/"

    case GetGoogleData(radius : String, query: String, ll: String)
    case GetPlaces(placeId : String)
    //    case GetPlacePhotos(photo_ref : String)
    
    var method: Alamofire.Method{
        switch (self) {
        case .GetGoogleData, .GetPlaces:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .GetGoogleData(let radius, let query, let ll):
            return "nearbysearch/json?location=\(ll)&radius=\(radius)&type=\(query)&key=AIzaSyAI7k38l_qxvzEOmBfg3uoutWZZmDT4zjY"
        case .GetPlaces(let placeId):
            return "details/json?placeid=\(placeId)&key=AIzaSyAI7k38l_qxvzEOmBfg3uoutWZZmDT4zjY"
            //       case .GetPlacePhotos(let photo_ref):
            //            return "photo?maxWidth=400&photoreference=\(photo_ref)&key=AIzaSyAI7k38l_qxvzEOmBfg3uoutWZZmDT4zjY"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        guard let URL = NSURL(string: Router.baseURLString) else{
            print("DEADLY ERROR : URL CREATION FAILED")
            return NSMutableURLRequest()
            
        }
        
        guard let url = NSURL(string: "\(path)", relativeToURL:URL) else{
            print("DEADLY ERROR : PATH CREATION FAILED")
            return NSMutableURLRequest()
        }
        
        let mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        switch self {
        //More cases can be handled here
        default:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        }
    }
}