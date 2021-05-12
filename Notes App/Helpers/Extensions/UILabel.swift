//
//  Mvmm Test
//
//  Created by Senthil Kumar on 19/04/18.
//  Copyright © 2018 Senthil Kumar. All rights reserved.
//  Developer : Senthil Kumar (@senmdu96)
//

import UIKit
import SwiftyMarkdown


extension UILabel {
    
    convenience public init(text: String, textColor: UIColor, font: UIFont? = .systemFont(ofSize: 14)) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
    }
    
    class func getErrorLabel(text:String,frame: CGRect) -> UILabel {
        let errorLabel = UILabel(frame: frame)
        errorLabel.text = text
        errorLabel.textColor = App.Color.textPrimary
        errorLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        errorLabel.textAlignment = .center
        return errorLabel
    }
    
    func applyAttributes(text:String) {
        let content = SwiftyMarkdown(string: text)
        content.link.fontName = "AvenirNext-Medium"
        content.link.fontSize = self.font?.pointSize ?? 17
        content.link.color = .systemBlue
        content.body.color = self.textColor ?? .white
        content.body.fontName = "AvenirNext-Medium"
        content.body.fontSize = self.font?.pointSize ?? 17
        content.bold.fontName = "AvenirNext-Bold"
        content.bold.color = self.textColor ?? .white
        content.bold.fontSize = (self.font?.pointSize ?? 17) + 2

        self.attributedText = content.attributedString()
    }
}


extension UITextView {
    
    func applyAttributes(text:String) {
        let content = SwiftyMarkdown(string: text)
        content.link.fontName = "AvenirNext-Medium"
        content.link.fontSize = self.font?.pointSize ?? 17
        content.link.color = .systemBlue
        content.body.color = self.textColor ?? .white
        content.body.fontName = "AvenirNext-Medium"
        content.body.fontSize = self.font?.pointSize ?? 17
        content.bold.fontName = "AvenirNext-Bold"
        content.bold.color = self.textColor ?? .white
        content.bold.fontSize = (self.font?.pointSize ?? 17) + 2

        self.attributedText = content.attributedString()
    }
}
