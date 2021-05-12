//
//  BaseViewController.swift
//  Notes
//
//  Created by Senthil on 09/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    public lazy var scrollView : UIScrollView  = {
        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .secondarySystemBackground
        self.view.addSubview(scroll)
        return scroll
    }()
    
    public lazy var mainView : UIView  = {
        let vw = UIView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .secondarySystemBackground
        return vw
    }()
    public lazy var topHeader : UIView = {
        let vw = UIView(frame: .zero)
        vw.backgroundColor = .clear
        vw.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(vw)
        view.trailingAnchor.constraint(equalTo: vw.trailingAnchor)
            .isActive = true
        vw.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            .isActive = true
        vw.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        vw.heightAnchor.constraint(equalToConstant: 85).isActive = true
        return vw
    }()
    
    public lazy var backButton : UIButton  = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 46, height: 50)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(backAct), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: App.Font.buttonConf), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "buttonColors")
        self.topHeader.addSubview(button)
        topHeader.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 16).isActive = true
        button.leadingAnchor.constraint(equalTo: topHeader.leadingAnchor, constant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 52).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    public func setScrollView() {
        scrollView.topAnchor.constraint(equalTo: self.topHeader.bottomAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        scrollView.addSubview(mainView)
        
        mainView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let hC = mainView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        hC.priority = UILayoutPriority(rawValue: 250)
        hC.isActive = true
    }
    
    
    public func addBackButton() {
        self.backButton.isHidden = false
    }
    @objc fileprivate func backAct() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

}

