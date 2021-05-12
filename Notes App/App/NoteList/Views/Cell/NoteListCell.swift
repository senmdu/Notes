//
//  NoteListCollectionViewCell.swift
//  Notes
//
//  Created by Senthil on 09/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit

class NoteListCell: UICollectionViewCell {
    
    static let reuseIdentifier = "notesCell"
    
    private lazy var title : UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = App.Font.avenirMedium(ofSize: 19)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    private lazy var subtitle : UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.font = App.Font.avenirMedium(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()
    
    private static let titleLeading :  CGFloat = 16
    
    private static let titleTrailing : CGFloat = 16
    
    public static var titleLeadingTrailing  : CGFloat {
        titleLeading + titleTrailing
    }
    private static let titleTop       :  CGFloat   = 16
    
    private static let titleBottom    :  CGFloat    = 10
    
    public static var titleTopBottom  : CGFloat {
        titleTop + titleBottom
    }
    public static let subtitleHeight  :  CGFloat   = 22
    
    public static let subtileBottom   :  CGFloat    = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    
    fileprivate func setupViews() {
        self.layer.cornerRadius = 10
        self.title.topAnchor.constraint(equalTo: self.topAnchor, constant: NoteListCell.titleTop).isActive = true
        self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: NoteListCell.titleLeading).isActive = true
        self.trailingAnchor.constraint(equalTo: self.title.trailingAnchor, constant: NoteListCell.titleTrailing).isActive = true
        self.subtitle.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: NoteListCell.titleBottom).isActive = true
        
        self.subtitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: NoteListCell.titleLeading).isActive = true
        self.trailingAnchor.constraint(equalTo: self.subtitle.trailingAnchor, constant: NoteListCell.titleTrailing).isActive = true
        self.bottomAnchor.constraint(equalTo: self.subtitle.bottomAnchor, constant: NoteListCell.subtileBottom).isActive = true
    }
    
    public func loadCell(_ data:NotesListModel) {
        self.title.text = data.title
        self.subtitle.text = data.date?.formattedString
        self.backgroundColor = data.backgRoundColor
    }

}
