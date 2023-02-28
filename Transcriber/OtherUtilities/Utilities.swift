//
//  Utilities.swift
//  Transcriber
//
//  Created by Amlan Jyoti on 28/10/21.
//

import Foundation
class Utilities {
    var DateTimeString: String?
    
    func getDocsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        return docsDirect
    }
    func getAudioFileUrl() -> URL? {
        do {
            let audioUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".m4a")
            return audioUrl
        } catch _ {
            return nil
        }
    }
    func getTextFileUrl() -> URL? {
        do {
            let textUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".txt")
            return textUrl

        }
        catch _ {
            return nil
        }
    }
    
    func getDateAndTime() -> String {
        if let dateT = DateTimeString {
            return dateT
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let timeString = formatter.string(from: date)
        return timeString
    }
}
