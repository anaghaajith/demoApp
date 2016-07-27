//
//  Extensions.swift
//  SalonUp
//
//  Created by Anagha Ajith on 23/07/16.
//  Copyright © 2016 Anagha Ajith. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
}

extension UIViewController {
    func addViewController (anyController: AnyObject) {
        if let viewController = anyController as? UIViewController {
            addChildViewController(viewController)
            view.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
        }
    }
}

extension UINavigationController{
    
    func setupNavigationBar() {
        self.navigationBar.barTintColor = UIColor.themeColor()
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        
    }
}

extension UIColor {
    class func themeColor() -> UIColor {
        return UIColor(red: 89/255.0, green: 89/255.0, blue: 113/255.0, alpha:1)
}
    
    class func ratingColor() -> UIColor {
        return UIColor(red: 157/255.0, green: 204/255.0, blue: 48/255.0, alpha:1)
    }
}

extension AssetImage {
    var image : UIImage {
        if let unwrappedImage = UIImage(named: self.rawValue){
            return unwrappedImage
        }
        else{
            print("ERROR: Asset with string '\(self.rawValue)' not found! [showing default image instead, Please verify asset string]")
            return UIImage(named: "errorImage")!
        }
    }
}

extension UIImageView{
    func clipToCircularImageView(){
        self.layer.cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
    }
    
    func setColor(color:UIColor){
        self.image!.imageWithRenderingMode(.AlwaysTemplate)
        self.tintColor = color
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}