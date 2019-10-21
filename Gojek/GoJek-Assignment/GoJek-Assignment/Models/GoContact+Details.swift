//
//  GoContact+Details.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import Foundation

extension GoContact {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(GoContact.self, from: data)
        self.init(id: me.id, firstName: me.firstName, lastName: me.lastName, profilePic: me.profilePic, favorite: me.favorite, url: me.url, phone:me.phone, email:me.email, createdAt: me.createdAt, updatedAt: me.updatedAt)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}
