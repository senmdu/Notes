//
//  App.swift
//  Notes
//
//  Created by Senthil Kumar Rajendran on 09/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

class App {
    
    // MARK: - Settings header title
    
   public struct Color {
       static let brandColor     : UIColor  =  UIColor(hex: "#EB4559")
       static let correctColor   : UIColor  =  UIColor(hex: "#79DF60")
       static let skipColor      : UIColor  =  UIColor(hex: "#FFA86D")
       static let cheatPenality  : UIColor  =  UIColor(hex: "#DE1B31")
       static let textPrimary    : UIColor  = .black
       static let primaryBackground         = UIColor(named: "primaryBackground")
       static let primaryBackground2        = UIColor(named: "primaryBackground2")
       static let primaryLabel              = UIColor(named: "primaryLabel")
       static let primaryLabel2             = UIColor(named: "primaryLabel2")
    }

    public struct Font {
        static func avenirMedium(ofSize size: CGFloat = 17) -> UIFont { UIFont(name: "AvenirNext-Medium", size: size) ?? UIFont.systemFont(ofSize: size) }
        static func avenirBold(ofSize size: CGFloat = 17) -> UIFont { UIFont(name: "AvenirNext-Bold", size: size) ?? UIFont.systemFont(ofSize: size) }
        static let buttonConf = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 20))
    }
    
   static public let delegate = (UIApplication.shared.delegate as? AppDelegate)
    
    class func device() -> UIUserInterfaceIdiom {
         return UIDevice.current.userInterfaceIdiom
    }
    
    
    class public func instiate() {
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.setMaximumDismissTimeInterval(1)
        SVProgressHUD.setMinimumSize(CGSize(width: 120, height: 120))
        SVProgressHUD.setForegroundColor(.black)
        SVProgressHUD.setBackgroundColor(.white)
        
        delegate?.window = UIWindow(frame: UIScreen.main.bounds)
        delegate?.window?.backgroundColor = .secondarySystemBackground
        delegate?.window?.makeKeyAndVisible()
        additionalConfig()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    

    
    class private func additionalConfig() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    class public func setMainRoot() {
        let newHome = NotesListController()
        let nav = UINavigationController(rootViewController: newHome)
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: App.Font.avenirMedium(ofSize: 20)]
        nav.navigationBar.barTintColor = UIColor.secondarySystemBackground
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: App.Font.avenirMedium(ofSize: 35)]
        
        delegate?.window?.rootViewController = nav
    }
    
    class public func showLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    class public func hideLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
}
