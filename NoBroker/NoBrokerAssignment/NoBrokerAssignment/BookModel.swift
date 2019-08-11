//
//  BookModel.swift
//  NoBrokerAssignment
//
//  Created by Ranjith Kumar on 7/30/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import Foundation

struct BookStore {
    private let keysToHighlight = ["author_name","genre","author_country"]
    var books:[String:[BookModel]] = [:]

    init(response:[[String:Any]]) {
        response.forEach { (dictionary) in
            guard let book = BookModel(resp: dictionary) else {return}

            if let authorValue = dictionary["author_name"] as? String  {
                if books.keys.contains(authorValue) {
                    if var existingArray = books[authorValue] {
                        existingArray.append(book)
                        books[authorValue] = existingArray
                    }else {
                        if let toRemove = books.index(forKey: authorValue) {
                            books.remove(at: toRemove)
                        }else {
                            debugPrint("There is some Error in dictionary")
                        }
                    }
                }else {
                    books[authorValue] = [book]
                }
            }

            if let genreValue = dictionary["genre"] as? String {
                if books.keys.contains(genreValue) {
                    if var existingArray = books[genreValue] {
                        existingArray.append(book)
                        books[genreValue] = existingArray
                    }else {
                        if let toRemove = books.index(forKey: genreValue) {
                            books.remove(at: toRemove)
                        }else {
                            debugPrint("There is some Error in dictionary")
                        }
                    }
                }else {
                    books[genreValue] = [book]
                }
            }

            if let authorCountryValue = dictionary["author_country"] as? String {
                if books.keys.contains(authorCountryValue) {
                    if var existingArray = books[authorCountryValue] {
                        existingArray.append(book)
                        books[authorCountryValue] = existingArray
                    }else {
                        if let toRemove = books.index(forKey: authorCountryValue) {
                            books.remove(at: toRemove)
                        }else {
                            debugPrint("There is some Error in dictionary")
                        }
                    }
                }else {
                    books[authorCountryValue] = [book]
                }
            }
        }
    }
}

struct BookModel {
    let id: String
    let bookTitle: String
    let authorName: String
    let genre: String
    let publisher: String
    let authorCountry: String
    let soldCount: Int
    let imageURL: String
}

extension BookModel {
    init?(resp:[String:Any]) {
        guard let id = resp["id"] as? String,
            let bookTitle = resp["book_title"] as? String,
            let authorName = resp["author_name"] as? String,
            let genre = resp["genre"] as? String,
            let publisher = resp["publisher"] as? String,
            let authorCountry = resp["author_country"] as? String,
            let soldCount = resp["sold_count"] as? Int,
            let imageURL = resp["image_url"] as? String
            else{
                return nil
        }
        self.init(id: id, bookTitle: bookTitle, authorName: authorName, genre: genre, publisher: publisher, authorCountry: authorCountry, soldCount: soldCount, imageURL: imageURL)
    }
}
