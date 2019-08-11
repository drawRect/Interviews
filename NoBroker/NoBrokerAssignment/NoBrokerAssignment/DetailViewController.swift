//
//  DetailViewController.swift
//  NoBrokerAssignment
//
//  Created by Ranjith Kumar on 7/30/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
            tableView.keyboardDismissMode = .interactive
        }
    }
    var selectedArray:[BookModel] = []
    var matchesArray:[BookModel] = []
    var isSearchBarEnabled:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearchBarEnabled {
            return self.matchesArray.count
        }else {
            return selectedArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if self.isSearchBarEnabled {
            let book = matchesArray[indexPath.row]
            cell.bookImageView.setImage(url: book.imageURL, style: .squared, completion: nil)
            cell.titleLabel.text = book.bookTitle
            cell.subTitleLabel.text = book.authorName
            cell.genreLabel.text = book.genre
        }else {
            let book = selectedArray[indexPath.row]
            cell.bookImageView.setImage(url: book.imageURL, style: .squared, completion: nil)
            cell.titleLabel.text = book.bookTitle
            cell.subTitleLabel.text = book.authorName
            cell.genreLabel.text = book.genre
        }
        return cell
    }
}


extension DetailViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton
        cancelButton?.isEnabled = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearchBarEnabled = false
            self.tableView.reloadData()
        }else {
            self.isSearchBarEnabled = true
            let searchText = searchText
            matchesArray = selectedArray.filter({$0.authorCountry.contains(find: searchText) || $0.bookTitle.contains(find: searchText) || $0.genre.contains(find: searchText) || $0.authorName.contains(find: searchText)})
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearchBarEnabled = false
        self.tableView.reloadData()
    }

}


extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

