//
//  RecentFiles.swift
//  AmahiAnywhere
//
//  Created by Abhishek Sansanwal on 12/08/19.
//  Copyright © 2019 Amahi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RecentFiles {
    
    struct Recent {
        var mtimeDate: Date
        var fileName: String
        var fileURL: String
        var serverName: String
        var mimeType: String
        var filesSize: String
        var fileDisplayText: String
        var authToken: String
    }
    
    static var sharedInstance = RecentFiles()
    let context = RecentsPersistenceService.persistentContainer.viewContext
    
    var recentFiles: [Recent] = []

    func setupStruct() {
        let recents = RecentsDatabaseHelper.shareInstance.getData()
        recentFiles.removeAll()
        for index in 0..<(recents.count) {
            
            let displayText = displayTextGenerator(day: Int(recents[index].day), month: Int(recents[index].month), year: Int(recents[index].year))
            let recent: Recent = Recent(mtimeDate: recents[index].mtimeDate, fileName: recents[index].fileName!, fileURL: recents[index].fileURL!, serverName: recents[index].serverName!, mimeType: recents[index].mimeType!, filesSize: recents[index].size!, fileDisplayText: displayText, authToken: recents[index].authToken!)
            recentFiles.append(recent)
        }
        do{
            try context.save()
        } catch {
            print("Data couldn't be saved!")
        }
    }
    
    func displayTextGenerator(day: Int, month: Int, year: Int) -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let presentYear =  components.year
        let presentMonth = components.month
        let presentDay = Int(components.day!)
        
        if presentYear == year {
            if presentMonth == month {
                if presentDay == day {
                    return "Today"
                }
                else {
                    if day - presentDay == 1 {
                        return "Yesterday"
                    }
                    else if day - presentDay <= 7 {
                        return "This Week"
                    }
                    else {
                        return "This Month"
                    }
                }
            }
            else {
                return "\(month) \(year)"
            }
        }
        else {
            return "\(year)"
        }
    }
    
    func getRecentFiles() -> [Recent] {
        setupStruct()
        return recentFiles
    }
}