//
//  CoreDataHelper.swift
//  Transcriber
//
//  Created by Amlan Jyoti on 31/10/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    init() {
        let container = NSPersistentContainer(name: "Transcriber")
        container.loadPersistentStores { (storeDescriprion, error) in
            if let error = error {
                print("Amlan :\(error)")
                
            }else {
                print("Amlan: Core Data Fine")
            }
        }
    }
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func storeTranscription(audioFileUrlString: String, textFileUrlString: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Transcription", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        transc.setValue(audioFileUrlString, forKey: "audioFileUrlString")
        transc.setValue(textFileUrlString, forKey: "textFileUrlString")
        do {
            try context.save()
            print("Amlan: SAVED")
        }catch {
            
        }
    }
    func getTranscription () -> [NSManagedObject]? {
        let fetRequest : NSFetchRequest<Transcription> = Transcription.fetchRequest()
        do {
            let searchResult = try getContext().fetch(fetRequest)
            print("AMLAN Num of result: \(searchResult.count)")
            for trans in searchResult as [NSManagedObject] {
                print("AMLAN REsult:\(trans.value(forKey: "audioFileUrlString"))")
            }
            return searchResult as [NSManagedObject]

        }catch {
            return nil
        }
    }
}
