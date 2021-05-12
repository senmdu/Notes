//
//  Helper.swift
//  Notes
//
//  Created by Senthil on 09/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit

class Helper {
    
    class func jsonDecode<T: Codable>(json:Data, type:T.Type)->T? {
        
        let decoder = JSONDecoder()
        do {
            let res = try decoder.decode(type, from: json)
            return res
        } catch {
            print(error)
            return nil
        }
    }
    
    class func getRandomColor(previousColor:UIColor? = nil) -> UIColor {
        let color1     =  UIColor(red: 254/255, green: 168/255, blue: 139/255, alpha: 1.0)
        let color2     =  UIColor(red: 254/255, green: 204/255, blue: 114/255, alpha: 1.0)
        let color3     =  UIColor(red: 227/255, green: 241/255, blue: 143/255, alpha: 1.0)
        let color4     =  UIColor(red: 93/255, green: 225/255, blue: 236/255, alpha: 1.0)
        let color5     =  UIColor(red: 218/255, green: 140/255, blue: 222/255, alpha: 1.0)
        let color6     =  UIColor(red: 103/255, green: 206/255, blue: 196/255, alpha: 1.0)
        let color7     =  UIColor(red: 255/255, green: 135/255, blue: 178/255, alpha: 1.0)
        
        var colors    = [color1,color2,color3,color4,color5,color6,color7]
        if previousColor != nil {
            if colors.contains(previousColor!) {
                colors.removeAll(where: {$0 == previousColor!})
            }
        }

        let random = Int(arc4random_uniform(UInt32(colors.count)))
        
        return colors[random]
    }
    
    class func getRandomColorImage() -> UIImage {
        
        
        return self.getImagewithColor(tintColor: self.getRandomColor())
        
        
    }
    
    
    class func getImagewithColor(tintColor: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 250, height: 250)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
   class func heightForLable(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        // pass string, font, LableWidth
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
         label.numberOfLines = 0
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         label.font = font
         label.text = text
         label.sizeToFit()

         return label.frame.height
    }
    class func getBold(chars:String,oldBounds:[(lowerBound:Int,upperBound:Int)]? = nil) -> (val:String,bounds:[(lowerBound:Int,upperBound:Int)]) {
        var str = Array(chars)
        var bounds = oldBounds ?? []
        var startRangeIndex : Int?
        var endRangeIndex : Int?
        for (index, st) in str.enumerated() {  if st == "*" { let nextIndex = index+1
            if nextIndex < str.count { if str[nextIndex] == "*" {
                if startRangeIndex == nil {
                     startRangeIndex = index
                }else if endRangeIndex == nil {
                    endRangeIndex = nextIndex
                }
                if let lowerBound = startRangeIndex, let upperBound = endRangeIndex {
                    str.remove(at: [lowerBound,lowerBound+1,upperBound,upperBound-1])
                    bounds.append((lowerBound: lowerBound, upperBound: upperBound-4))
                    return getBold(chars:String(str), oldBounds: bounds)
                }
            } }
        } }
        return (val:String(str),bounds:bounds)
    }
    
    class func saveImage(name:String,image: UIImage) -> URL? {
        var url : URL?
        guard let data = image.jpegData(compressionQuality: 0.8) ?? image.pngData() else {
            return url
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
           return url
        }
         url = directory.appendingPathComponent("\(name).jpg")
        do {
            try data.write(to: url!)
            return url
        } catch {
            print(error.localizedDescription)
            return url
        }
    }
    
    class func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }

}

extension Array {

    mutating func remove(at indexs: [Int]) {
        guard !isEmpty else { return }
        let newIndexs = Set(indexs).sorted(by: >)
        newIndexs.forEach {
            guard $0 < count, $0 >= 0 else { return }
            remove(at: $0)
        }
    }

}
