//
//  Human.swift
//  UnitTestsWithQuick_2_18
//
//  Created by Лаура Есаян on 22.05.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation
import RealmSwift

infix operator =?

class Human: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var height: Float = 0
    @objc dynamic var weight: Float = 0
    @objc dynamic var dateOfBirth = Date()
    
    static func =?(human1: Human, human2: Human) -> Bool {
        if human1.name == human2.name, human1.dateOfBirth == human2.dateOfBirth, human1.height == human2.height,
            human1.weight == human2.weight {
            return true
        }
        
        return false
    }
}

class HumanHandler {
    static let shared = HumanHandler()
    private let realm = try! Realm()
    
    func addHuman(human: Human) {
        try! realm.write {
            realm.add(human)
        }
    }
    
    func removeHuman(human: Human) -> Bool {
        for readHuman in realm.objects(Human.self) {
            if readHuman =? human {
                try! realm.write {
                    realm.delete(readHuman)
                }
                
                return true
            }
        }
        
        return false
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func getTheYoungestHuman() -> Human? {
        if realm.objects(Human.self).count > 0 {
            var theYoungestHuman = realm.objects(Human.self)[0]
            for human in realm.objects(Human.self) {
                if isYounger(human1: human, human2: theYoungestHuman) {
                    theYoungestHuman = human
                }
            }
            
            return theYoungestHuman
        }
        
        return nil
    }
    
    func getTheOldestHuman() -> Human? {
        if realm.objects(Human.self).count > 0 {
            var theOldestHuman = realm.objects(Human.self)[0]
            for human in realm.objects(Human.self) {
                if !isYounger(human1: human, human2: theOldestHuman) {
                    theOldestHuman = human
                }
            }
            
            return theOldestHuman
        }

        return nil
    }
    
    private func isYounger(human1: Human, human2: Human) -> Bool {
        // ">" 'cos timeIntervalSinceNow is negative
        return human1.dateOfBirth.timeIntervalSinceNow > human2.dateOfBirth.timeIntervalSinceNow
    }
}
