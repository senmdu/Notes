//
//  AppDelegate.swift
//  Notes
//
//  Created by Senthil Kumar Rajendran on 08/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        App.instiate()
        App.setMainRoot()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataHelper.sharedInstance.saveContext()
    }

}

