//
//  NoteDetailController.swift
//  Notes
//
//  Created by Senthil on 09/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit
import SwiftyMarkdown
import SDWebImage

class NoteDetailController: BaseViewController {
    
    // MARK: -  UI & DataSource Properties
    private lazy var headerImage : UIImageView  = {
        let vw = UIImageView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    private lazy var titleLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = App.Font.avenirBold(ofSize: 22)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addSubview(label)
        return label
    }()
    private lazy var subtitleLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.minimumScaleFactor = 0.5
        label.font = App.Font.avenirMedium(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addSubview(label)
        return label
    }()
    private lazy var contentLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = App.Font.avenirMedium(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addSubview(label)
        return label
    }()
    public var model : NotesListModel?
    
    // MARK: - Controller Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        self.loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    // MARK: - UI Methods
    fileprivate func loadUI() {
        self.view.backgroundColor = .secondarySystemBackground
        self.addBackButton()
        setScrollView()
        addContentUI()
    }
    
    fileprivate func addContentUI() {
        self.mainView.addSubview(headerImage)
        headerImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        headerImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: headerImage.trailingAnchor).isActive = true
        if let mod = self.model, mod.imageURL != nil {
            headerImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        }else {
            headerImage.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        self.titleLabel.topAnchor.constraint(equalTo: self.headerImage.bottomAnchor, constant: 10).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 20).isActive = true
        self.mainView.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 20).isActive = true
        self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16).isActive = true
        
        self.subtitleLabel.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 20).isActive = true
        self.mainView.trailingAnchor.constraint(equalTo: self.subtitleLabel.trailingAnchor, constant: 20).isActive = true
        self.contentLabel.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 16).isActive = true
        
        self.contentLabel.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 20).isActive = true
        self.mainView.trailingAnchor.constraint(equalTo: self.contentLabel.trailingAnchor, constant: 20).isActive = true
        self.mainView.bottomAnchor.constraint(greaterThanOrEqualTo: self.contentLabel.bottomAnchor, constant: 12).isActive = true
    }
    
    // MARK: -  Data Methods
    
    fileprivate func loadData() {
        if let note = self.model {
            self.titleLabel.text = note.title
            self.subtitleLabel.text = note.date?.formattedString
            if  let content = note.body {
                self.contentLabel.applyAttributes(text: content)
            }
            self.headerImage.sd_setImage(with: note.imageURL,placeholderImage: Helper.getRandomColorImage())
            
        }
        
    }
}



