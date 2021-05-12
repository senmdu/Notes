//
//  Mvmm Test
//
//  Created by Senthil Kumar on 19/04/18.
//  Copyright © 2018 Senthil Kumar. All rights reserved.
//  Developer : Senthil Kumar (@senmdu96) - senmdu96@gmail.com
//

import UIKit


extension Date {
    
    var formattedString : String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd,yyyy"
        dateFormat.timeZone = NSTimeZone.local
        return dateFormat.string(from: self)
    }
    
    var formattedStringWithSlash : String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm a"
        dateFormat.timeZone = NSTimeZone.local
        return dateFormat.string(from: self)
    }
    
    var formattedStringWithDash : String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy HH-mm a"
        dateFormat.timeZone = NSTimeZone.local
        return dateFormat.string(from: self)
    }
    
    var millisecondsSince1970:Int64 {
           return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

   init(milliseconds:Int64) {
       self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
   }
}
