//
//  GoContacts.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import Foundation

class GoContacts {
    private(set) var people: [GoContact] = []
    public var orderedPeople:[String:[GoContact]] = [:]
}

extension GoContacts {
    convenience init(data: Data) throws {
        self.init()
        self.people = try newJSONDecoder().decode([GoContact].self, from: data)
        self.doAToZCombination()
    }
    
    private func doAToZCombination() {
        var unorderedPeople:[GoContact] = []
        unorderedPeople = people.sorted(by: { $0.name < $1.name })
        unorderedPeople.forEach { (contact) in
            guard let char = contact.firstName.first else {fatalError("No first name found")}
            let charString = String(char).uppercased()
            if orderedPeople.keys.contains(charString) {
                if var existingArray = orderedPeople[charString] {
                    existingArray.append(contact)
                    orderedPeople[charString] = existingArray
                }else {
                    if let toRemove = orderedPeople.index(forKey: charString) {
                        orderedPeople.remove(at: toRemove)
                    }else {
                        fatalError("There is some error in dictionary")
                    }
                }
            }else {
                orderedPeople[charString] = [contact]
            }
        }
    }
}

extension GoContacts {
    var sections:[String] {
        return Array(orderedPeople.keys.sorted(by: {$0 < $1}))
    }
    
    func listOnIndexPath(section:Int) -> [GoContact] {
        let key = sections[section]
        let list = self.orderedPeople[key]
        return list!
    }
    
    func contactOnRow(indexPath:IndexPath) -> GoContact {
        let list = listOnIndexPath(section: indexPath.section)
        let contact = list[indexPath.row]
        return contact
    }
}
