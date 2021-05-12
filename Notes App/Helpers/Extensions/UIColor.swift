//
//  Mvmm Test
//
//  Created by Senthil Kumar on 19/04/18.
//  Copyright © 2018 Senthil Kumar. All rights reserved.
//  Developer : Senthil Kumar (@senmdu96) - senmdu96@gmail.com
//

import UIKit


extension UIColor {

    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(white: 0, alpha: 1)
        }else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: CGFloat(1.0))
        }
        
        
    }
    
     /**
    This method returns colors modified by percentage value of color represented by the current object.
    */
     func getModified(byPercentage percent: CGFloat) -> UIColor? {

       var red: CGFloat = 0.0
       var green: CGFloat = 0.0
       var blue: CGFloat = 0.0
       var alpha: CGFloat = 0.0

       guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
         return nil
       }

       // Returns the color comprised by percentage r g b values of the original color.
       let colorToReturn = UIColor(displayP3Red: min(red + percent / 100.0, 1.0), green: min(green + percent / 100.0, 1.0), blue: min(blue + percent / 100.0, 1.0), alpha: 1.0)

       return colorToReturn
     }

}
