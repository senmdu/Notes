//
//  Mvmm Test
//
//  Created by Senthil Kumar on 19/04/18.
//  Copyright © 2018 Senthil Kumar. All rights reserved.
//  Developer : Senthil Kumar (@senmdu96) - senmdu96@gmail.com
//

import UIKit


extension UIViewController {
    
    var storyboardId: String? {
           return value(forKey: "storyboardIdentifier") as? String
    }
    
    func hideKeyboardWhenTappedAround() {
           let tapGesture = UITapGestureRecognizer(target: self,
                            action: #selector(hideKeyboard))
           tapGesture.cancelsTouchesInView = false
           view.addGestureRecognizer(tapGesture)
    }

   @objc func hideKeyboard() {
       view.endEditing(true)
   }
    
    func showAlert(title:String,subTitle:String?) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func errorView(in view: UIView,error:String, action: Selector) -> UIView {
        let errorView = UIView(frame: view.bounds)
        let errorLabel = UILabel.getErrorLabel(text: error, frame: CGRect(x: 0,y: errorView.bounds.size.height/2 - 60,
              width: errorView.bounds.size.width,
        height: 50))
        errorView.addSubview(errorLabel)
        let retryButton = UIButton.getRetryButton(frame: CGRect(x: (errorView.bounds.size.width / 2) - 75,y: errorLabel.frame.maxY,
              width: 150,
        height: 40))
        retryButton.addTarget(self, action: action, for: .touchUpInside)
        errorView.addSubview(retryButton)
        return errorView
     }
    
    func showPopup(_ vc: UIViewController) {
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false) {
            var dimBackground =  self.view.viewWithTag(55)
            if  dimBackground != nil {
                return
            }
            dimBackground = UIView(frame: self.navigationController?.view.frame ?? self.view.frame)
            dimBackground?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            if self.navigationController != nil {
             self.navigationController?.view.addSubview(dimBackground!)
            }else {
             self.view.addSubview(dimBackground!)
            }
        }
    }
}


extension UITableView {
func reloadWithAnimation() {
    self.reloadData()
//    let tableViewHeight = self.bounds.size.height
//    let cells = self.visibleCells
//    var delayCounter = 0
//    for cell in cells {
//        cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
//    }
//    for cell in cells {
//        UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//            cell.transform = CGAffineTransform.identity
//        }, completion: nil)
//        delayCounter += 1
//    }
}
}
