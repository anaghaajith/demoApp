//
//  SalonCell.swift
//  SalonUp
//
//  Created by Anagha Ajith on 18/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import UIKit
import GoogleMaps

class SalonCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    var attributionTextView = UITextView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func createCell(data : SalonDetails, index : Int) {
        
        nameLabel.text = data.name
        nameLabel.textColor = UIColor.themeColor()
        areaLabel.text = data.area

        if let unwrappedRate = data.rating as String? {
            rating.text = unwrappedRate
            
            
        }
        else {
            rating.text = "N.A"
        }
        rating.clipsToBounds = true
        rating.layer.cornerRadius = 3
        rating.backgroundColor = UIColor.ratingColor()
        
        if let unwrappedReviews = data.reviews?.count {
            reviewsCount.text = String(unwrappedReviews) + " reviews"
        }
        else
        {
            reviewsCount.text = "0 reviews"
        }
        
        
        if let unwrappedTiming = data.open_now as Bool? {
            if unwrappedTiming == true {
                timingLabel.text = "Open Now"
                timingLabel.textColor = UIColor.ratingColor()
            }
            else {
                timingLabel.text = "Closed Now"
                timingLabel.textColor = UIColor.redColor()
            }
        }
        else {
            timingLabel.text = "N.A"
            timingLabel.textColor = UIColor.darkGrayColor()
            
        }
        
        if let unwrappedDistance = data.distance as String? {
            distanceLabel.text = unwrappedDistance
        }
        var image : UIImage
        let myInsets : UIEdgeInsets = UIEdgeInsetsMake(16,16 ,16,16 )
        image = AssetImage.roundedCornerCard.image
        image = image.resizableImageWithCapInsets(myInsets)
        backgroundImageView.image = image
        
        
    }
}
