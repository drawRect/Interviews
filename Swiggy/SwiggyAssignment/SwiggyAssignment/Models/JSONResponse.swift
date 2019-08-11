//
//  JSONModel.swift
//  SwiggyAssignment
//
//  Created by Ranjith Kumar on 3/16/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import Foundation

struct JSONResponse: Codable {
    let variants: Variants
}

struct Variants: Codable {
    let variantGroups: [VariantGroup]
    let excludeList: [[ExcludeList]]

    enum CodingKeys: String, CodingKey {
        case variantGroups = "variant_groups"
        case excludeList = "exclude_list"
    }
}

struct ExcludeList: Codable {
    let groupID, variationID: String

    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case variationID = "variation_id"
    }
}

struct VariantGroup: Codable {
    let groupID, name: String
    let variations: [Variation]

    enum CodingKeys: String, CodingKey {
        case groupID = "group_id"
        case name, variations
    }
}

struct Variation: Codable {
    let name: String
    let price, variationDefault: Int
    let id: String
    let inStock: Int
    let isVeg: Int?

    enum CodingKeys: String, CodingKey {
        case name, price
        case variationDefault = "default"
        case id, inStock, isVeg
    }
}
