//
//  NotesListController.swift
//  Notes
//
//  Created by Senthil Kumar Rajendran on 08/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit

class NotesListController: BaseViewController {
    
    // MARK: -  UI & DataSource Properties
    private var dataSource = [NotesListModel]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: NoteListLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection)
        collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collection.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collection.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return collection
    }()
    
    private lazy var addNoteButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 27.5
        button.backgroundColor = UIColor.black
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus", withConfiguration: App.Font.buttonConf), for: .normal)
        view.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: 55).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 26)
            .isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: button.safeAreaLayoutGuide.bottomAnchor, constant: 16)
            .isActive = true
        return button
    }()
    
    // MARK: - Controller Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retriveData()
        loadUI()
        self.loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        self.collectionView.performBatchUpdates({
             self.collectionView.setCollectionViewLayout(self.collectionView.collectionViewLayout, animated: true)
            
        }, completion: nil)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("deinit NotesListController")
    }
    
    // MARK: - UI Methods
    fileprivate func loadUI() {
        self.title = "Notes"
        self.view.backgroundColor = .secondarySystemBackground
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 10)
        collectionView.register(NoteListCell.self, forCellWithReuseIdentifier: NoteListCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        addNoteButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        if let layout = collectionView.collectionViewLayout as? NoteListLayout {
            layout.delegate  = self
        }
    }
    
    // MARK: -  Data Methods
    
    /* Getting data from server and save it to offline*/
    fileprivate func loadData() {
        self.retriveData()
        if self.dataSource.count == 0 {
            App.showLoader()
        }
        NetworkManager.shared.get(.notes) { (response) in
            App.hideLoader()
            if let data = response.result {
                if let list =   Helper.jsonDecode(json: data, type: [NotesListResult].self) {
                    if CoreDataHelper.sharedInstance.createNotes(notes: NotesListModel.load(from: list)) == true {
                        self.retriveData()
                    }
                }
            }else {
                self.showAlert(title: "Something went wrong", subTitle: nil)
            }
        }
    }
    /* Retriving local data*/
    private func retriveData() {
        self.dataSource =  CoreDataHelper.sharedInstance.retrieveAllNotes().sorted(by: {$0.timestamp ?? 0 > $1.timestamp ?? 0})
    }
    
    // MARK: -  Custom Actions
    
    @objc fileprivate func addNote() {
        let controller = NoteCreateController()
        controller.noteCreated = {(note) in
            let newIndexPath = IndexPath(item: 0, section: 0)
            self.dataSource.insert(note, at: 0)
            self.collectionView.insertItems(at: [newIndexPath])
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: -  CollectionView Delegate and datasource

extension NotesListController : UICollectionViewDelegate,UICollectionViewDataSource,NoteListLayoutDelegate{
    
    func collectionView(collectionView: UICollectionView, heightForTitleAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let data = dataSource[indexPath.row]
        return Helper.heightForLable(text: data.title ?? "", font: App.Font.avenirMedium(ofSize: 19), width: width - NoteListCell.titleLeadingTrailing) + NoteListCell.titleTopBottom
    }
    
    func collectionView(collectionView: UICollectionView, heightForSubTitleAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        
        return NoteListCell.subtitleHeight + NoteListCell.subtileBottom
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteListCell.reuseIdentifier, for: indexPath) as? NoteListCell else {
            return UICollectionViewCell()
        }
        let data = self.dataSource[indexPath.row]
        cell.loadCell(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = NoteDetailController()
        controller.model = self.dataSource[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

