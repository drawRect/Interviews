//
//  GoContact.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 11/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import Foundation

class GoContact: Codable {
    
    var id: Int
    var firstName: String
    var lastName: String
    var profilePic: String
    var favorite: Bool
    var url: String?
    var phone: String?
    var email: String?
    var createdAt: String?
    var updatedAt: String?
    var isFetchedDetails:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite = "favorite"
        case url
        case phone = "phone_number"
        case email = "email"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int, firstName: String, lastName: String, profilePic: String, favorite: Bool, url: String?, phone:String?, email: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.favorite = favorite
        self.url = url
        self.phone = phone
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var name:String {
      return firstName + " " + lastName
    }
}

extension GoContact {
    var blob:[String:Any] {
        return [
            CodingKeys.id.rawValue:self.id,
            CodingKeys.firstName.rawValue:self.firstName,
            CodingKeys.lastName.rawValue:self.lastName,
            CodingKeys.profilePic.rawValue:self.profilePic,
            CodingKeys.favorite.rawValue:self.favorite,
            CodingKeys.url.rawValue:self.url as Any,
            CodingKeys.phone.rawValue:self.phone as Any,
            CodingKeys.email.rawValue:self.email as Any,
            CodingKeys.createdAt.rawValue:self.createdAt as Any,
            CodingKeys.updatedAt.rawValue:self.updatedAt as Any
        ]
    }
}
