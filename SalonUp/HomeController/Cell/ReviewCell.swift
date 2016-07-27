//
//  ReviewCell.swift
//  SalonUp
//
//  Created by Anagha Ajith on 23/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func createCell(data : NSDictionary) {
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
        profileImageView.clipsToBounds = true
        
        if let name = data.valueForKey("author_name") as? String {
            username.text = name.capitalizedString
            
        }
        
        if let userRating = data.valueForKey("rating") as? Int {
            
            ratingView.rating = Double(userRating)
        }
        
        if let userMessage = data.valueForKey("text") as? String {
            review.text = userMessage
        }
    }
}
