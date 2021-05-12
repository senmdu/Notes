//
//  NotesListModel.swift
//  Notes
//
//  Created by Senthil on 09/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import UIKit


struct NotesListModel {
    public var id : String?
    public var title : String?
    public var body : String?
    public var timestamp : Double?
    public var imageURL : URL?
    public var backgRoundColor : UIColor?
    
    public var date : Date? {
        if let time = timestamp {
            let date = Date(timeIntervalSince1970: time)
            return date
        }
        return nil
        
    }
    
    public static func load(from notesResult: [NotesListResult]) -> [NotesListModel] {
        let notes = notesResult.compactMap { (note) -> NotesListModel in
            let timeStamp = Double(note.time)
            return NotesListModel(id: note.id, title: note.title, body:  note.body, timestamp: timeStamp,imageURL: note.image)
        }
        return loadColors(notes: notes)
    }
    
    public static func loadColors(notes:[NotesListModel]) -> [NotesListModel] {
        var notes = notes
        for i in 0..<notes.count {
            if i > 0 {
                notes[i].backgRoundColor = Helper.getRandomColor(previousColor: notes[i-1].backgRoundColor)
            }else {
                notes[i].backgRoundColor =  Helper.getRandomColor()
            }
        }
        return notes
    }
}

struct NotesListResult : Decodable & Encodable {
    public var id : String
    public var title : String
    public var time : String
    public var body : String
    public var image : URL?
}

