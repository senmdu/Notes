//
//  Mvmm Test
//
//  Created by Senthil Kumar on 19/04/18.
//  Copyright © 2018 Senthil Kumar. All rights reserved.
//  Developer : Senthil Kumar (@senmdu96) - senmdu96@gmail.com
//

import UIKit
import LocalAuthentication

extension UIApplication {
    var statusBarView: UIView? {
          if #available(iOS 13.0, *) {
              let tag = 3848245

              let keyWindow = UIApplication.shared.connectedScenes
                  .map({$0 as? UIWindowScene})
                  .compactMap({$0})
                  .first?.windows.first

              if let statusBar = keyWindow?.viewWithTag(tag) {
                  return statusBar
              } else {
                  let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                  let statusBarView = UIView(frame: height)
                  statusBarView.tag = tag
                  statusBarView.layer.zPosition = 999999

                  keyWindow?.addSubview(statusBarView)
                  return statusBarView
              }

          } else {

              if responds(to: Selector(("statusBar"))) {
                  return value(forKey: "statusBar") as? UIView
              }
          }
          return nil
        }
}

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error thru Crashlytics
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                fatalError()
            }
        } else {
            return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
    
}
