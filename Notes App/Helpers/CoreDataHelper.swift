//
//  CoreDataHelper.swift
//  Notes
//
//  Created by Senthil on 09/05/21.
//  Copyright © 2021 Sen - senmdu96@gmail.com. All rights reserved.
//

import CoreData

 class CoreDataHelper {
    
    // MARK: - Core Data stack
    
    let entityName = "Notes"

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Notes_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static let sharedInstance = CoreDataHelper()
    private  init() {}
    
    func retrieveAllNotes() ->[NotesListModel] {
        
 
        let managedContext = self.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count > 0
            {   if let notes = results as? [Notes] {
                let note =  notes.compactMap({NotesListModel(id: $0.id, title: $0.title, body: $0.body, timestamp: $0.time,imageURL: URL(string: $0.image ?? ""))})
                return NotesListModel.loadColors(notes: note)
                }
            }
                
            
        }
        catch let error as NSError {
            Swift.debugPrint("Could not fetch \(error), \(error.userInfo)")
        }
        
        return []
        
    }
    
    func createNotes(notes:[NotesListModel]) -> Bool {
        var changes : Bool?
        for item in notes {
            let noteCreated = self.createNote(note: item)
            if changes == nil && noteCreated == true{
                changes = true
            }
        }
        return changes ?? false
    }
    
    func createNote(note:NotesListModel) -> Bool {
        let id = note.id ?? "\(Date().timeIntervalSince1970)"
        var changes = false
        
        let managedContext = self.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: self.entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        do
        {
            if let fetchResults = try managedContext.fetch(fetchRequest) as? [Notes], fetchResults.count > 0 {
                let noteModel = fetchResults[0]
                if note.id != noteModel.id {
                    changes = true
                    noteModel.id = note.id
                }
                if note.title != noteModel.title {
                    noteModel.title = note.title
                    changes = true
                }
                if note.body != noteModel.body {
                    noteModel.body = note.body
                    changes = true
                }
                if let time = note.timestamp {
                    if time != noteModel.time {
                        noteModel.time =  time
                        changes = true
                    }
                }
                if note.imageURL?.absoluteString != noteModel.image {
                    noteModel.image = note.imageURL?.absoluteString
                    changes = true
                }
                
            } else {
                guard let entityDescription =  NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else { return false}
                let item = Notes(entity: entityDescription, insertInto: managedContext)
                item.title = note.title
                item.body = note.body
                if let timeStamp = note.timestamp {
                    item.time = timeStamp
                }
                item.id = note.id
                item.image = note.imageURL?.absoluteString
                changes = true
            }
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }

        return changes
    }

    func deleteAllData(){
        let managedContext = self.persistentContainer.viewContext
        
        //FIRST DELETE ALL RECORDS
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
        } catch _ as NSError {
            // TODO: handle the error
        }
    }
    
    
}
