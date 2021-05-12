//
//  NoteCreateController.swift
//  Notes
//
//  Created by Senthil on 12/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class NoteCreateController: BaseViewController {

    // MARK: -  UI & DataSource Properties
    
    public var noteCreated : ((NotesListModel)->())?
    
    private var attachedImage : UIImage? {
        didSet {
            if attachedImage != nil {
                self.attachButton.badge = "1"
            }else {
                self.attachButton.badge = ""
            }
        }
    }
    
    private lazy var saveButton : UIButton  = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font =  App.Font.avenirBold(ofSize: 18)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "buttonColors")
        self.topHeader.addSubview(button)
        topHeader.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 16).isActive = true
        topHeader.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var attachButton : BadgeButton  = {
        let button = BadgeButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.setImage(UIImage(systemName: "paperclip", withConfiguration: App.Font.buttonConf), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "buttonColors")
        self.topHeader.addSubview(button)
        topHeader.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 16).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
   // var titleText = ""
    private lazy var titleTextView : BaseTextView = {
        let textView = BaseTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(textView)
        textView.backgroundColor = .clear
        textView.font = App.Font.avenirMedium(ofSize: 28)
        textView.placeholderFont = App.Font.avenirMedium(ofSize: 28)
        textView.placeholder = "Title"
        textView.placeholderColor = .lightGray
        textView.isScrollEnabled = false
        textView.textColor = .label
        textView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16).isActive = true
        textView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16).isActive = true
        mainView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 16).isActive = true
       // textView.applyAttributes(text: titleText)
        return textView
    }()
    private var bodyText = ""
    private lazy var bodyTextView : BaseTextView = {
        let textView = BaseTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(textView)
        textView.backgroundColor = .clear
        textView.font = App.Font.avenirMedium(ofSize: 20)
        textView.placeholderFont = App.Font.avenirMedium(ofSize: 20)
        textView.placeholder = "Type Something..."
        textView.placeholderColor = .lightGray
        textView.isScrollEnabled = false
        textView.textColor = .label
        textView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20).isActive = true
        textView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16).isActive = true
        mainView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 16).isActive = true
        self.mainView.bottomAnchor.constraint(greaterThanOrEqualTo: textView.bottomAnchor, constant: 12).isActive = true
        textView.applyAttributes(text: bodyText)
        return textView
    }()
    
    // MARK: - Controller Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    deinit {
        print("deint note create")
    }
    // MARK: - UI Methods
    
    fileprivate func loadUI() {
        self.view.backgroundColor = .secondarySystemBackground
        self.addBackButton()
        setScrollView()
        self.scrollView.keyboardDismissMode = .interactive
        self.saveButton.addTarget(self, action: #selector(saveAct), for: .touchUpInside)
        self.attachButton.addTarget(self, action: #selector(attachAct), for: .touchUpInside)
        self.titleTextView.delegate = self
        self.bodyTextView.delegate = self
    }
    
    // MARK: -  Custom Actions
    
    @objc fileprivate func saveAct() {
        self.view.endEditing(true)
        let text = self.titleTextView.text
        guard text?.count ?? 0 > 0 else {
            self.titleTextView.becomeFirstResponder()
            self.showAlert(title: "Please enter title", subTitle: nil)
            return
        }
        guard self.bodyText.count > 0 else {
            self.bodyTextView.becomeFirstResponder()
            self.showAlert(title: "Please write something", subTitle: nil)
            return
        }
        let timeStamp = Date().timeIntervalSince1970
        var imageUrl : URL?
        if let attach = attachedImage {
            imageUrl = Helper.saveImage(name: "\(timeStamp)", image: attach)
        }
        let note = NotesListModel(id: "\(timeStamp)", title: text, body: bodyText, timestamp: timeStamp, imageURL: imageUrl, backgRoundColor: Helper.getRandomColor())
        if CoreDataHelper.sharedInstance.createNote(note: note) {
            self.noteCreated?(note)
            self.navigationController?.popViewController(animated: true)
        }else {
            self.showAlert(title: "Something went wrong", subTitle: nil)
        }
    }
    
    @objc fileprivate func attachAct() {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: (self.attachedImage != nil) ? "Change Image" :"Attach Image", style: .default, handler: { (_) in
            self.pickPhoto()
        }))
        if attachedImage != nil {
            alert.addAction(UIAlertAction(title: "Remove Attachment", style: .destructive, handler: { (_) in
                self.attachedImage = nil
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    

}


// MARK: -   TextView & Picker Delegates

extension NoteCreateController : UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.titleTextView {
          //  self.titleText = textView.text
           // textView.applyAttributes(text: textView.text)
        }else if textView == self.bodyTextView {
            self.bodyText = textView.text
            textView.applyAttributes(text: textView.text)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.titleTextView {
//            textView.typingAttributes = [NSAttributedString.Key.font : App.Font.avenirMedium(ofSize: 28),
//                                         NSAttributedString.Key.foregroundColor : UIColor.white]
//            textView.text = titleText
        }else if textView == self.bodyTextView {
            textView.typingAttributes = [NSAttributedString.Key.font : App.Font.avenirMedium(ofSize: 20),
                                         NSAttributedString.Key.foregroundColor : UIColor.label]
            textView.text = bodyText
        }

    }
    
    private func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    print("Button capture")
                  let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false

                    present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
               if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                attachedImage = image
        }
    }
    
    

/*
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            textView.applyAttributes(text: textView.text)
        }
   }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = (textView.text! as NSString).replacingCharacters(in: range, with: text)
            if let last = str.last, last == " " {
                print("SPACE!")

            }else if let last = str.last, last == ")"  {
                textView.applyAttributes(text: textView.text+")")
                textView.textColor = .white
                textView.typingAttributes = [NSAttributedString.Key.font : App.Font.avenirMedium(ofSize: 30),
                                             NSAttributedString.Key.foregroundColor : UIColor.white]
                return false
            }else{
                print(str.last ?? "")
            }

            return true

    }
*/
    
}
