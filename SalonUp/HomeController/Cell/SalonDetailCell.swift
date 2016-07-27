//
//  SalonDetailCell.swift
//  SalonUp
//
//  Created by Anagha Ajith on 23/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import UIKit

//Delegate method for call button pressed
protocol CallButtonPressedDelegate {
    func callFailed()
    
}

class SalonDetailCell: UITableViewCell {
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var formattedAddress: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    var delegate = CallButtonPressedDelegate?()
    var phoneNo = String()
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func createCell(data :SalonDetails, day : Int) {
        locationIcon.image = AssetImage.location.image.imageWithRenderingMode(.AlwaysTemplate)
        locationIcon.tintColor = UIColor.lightGrayColor()
        distanceIcon.image = AssetImage.distance.image.imageWithRenderingMode(.AlwaysTemplate)
        distanceIcon.tintColor = UIColor.lightGrayColor()
        clockIcon.image = AssetImage.clock.image.imageWithRenderingMode(.AlwaysTemplate)
        clockIcon.tintColor = UIColor.lightGrayColor()
       
        callButton.layer.borderColor = UIColor.ratingColor().CGColor
        callButton.layer.borderWidth = 1
        callButton.clipsToBounds = true
        callButton.layer.cornerRadius = 3
        callButton.addTarget(self, action: #selector(SalonDetailCell.callButtonPressed), forControlEvents: .TouchUpInside)
        
        nameLabel.text = data.name
        nameLabel.textColor = UIColor.themeColor()
        if let unwrappedAddress = data.address as String? {
            formattedAddress.text = unwrappedAddress.capitalizedString
            
        }
        
        if let unwrappedRate = data.rating as String? {
            rating.text = unwrappedRate
            
        }
        else {
            rating.text = "N.A"
        }
        rating.clipsToBounds = true
        rating.layer.cornerRadius = 3
        rating.backgroundColor = UIColor.ratingColor()
        rating.textColor = UIColor.whiteColor()
        
        if let unwrappedReviewsCount = data.reviews?.count {
            reviews.text = String(unwrappedReviewsCount) + " reviews"
        }
        else
        {
            reviews.text = "0 reviews"
        }
        
        if let unwrappedTimings = data.timings as NSArray? {
            
            timingLabel.text = unwrappedTimings[day] as? String
        }
        else {
            timingLabel.text = "N.A"
        }
        
        
        if let unwrappedDistance = data.distance as String? {
            distanceLabel.text = unwrappedDistance
        }
        
        if let unwrappedPhone = data.phoneNo as String?{
            phoneNo = unwrappedPhone
        }
        
    }
    
    
    func callButtonPressed(){
        if let ph = phoneNo as String? {
            let phone = "tel://\(ph.removeWhitespace())"
            if let url : NSURL = NSURL(string:phone) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        else {
            delegate?.callFailed()
        }
    }
    
}
