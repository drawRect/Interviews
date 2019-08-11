//
//  ViewController.swift
//  NoBrokerAssignment
//
//  Created by Ranjith Kumar on 7/30/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
            tableView.tableFooterView = UIView()
        }
    }
    var dataSource:BookStore?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.loadSampleJSON()
    }

    private func loadSampleJSON() {
        let url = Bundle.main.url(forResource: "sample.json", withExtension: nil)
        do {
            let data = try Data(contentsOf: url!)
            if let response = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [[String:Any]] {
                self.dataSource = BookStore(response: response)
                self.tableView.reloadData()
            }
        }catch(let e) {
            print("Error:\(e)")
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.books.keys.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let key = Array((self.dataSource?.books.keys)!)[indexPath.row]
        cell.textLabel?.text = key
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let key = Array((self.dataSource?.books.keys)!)[indexPath.row]
        let selectedArray = self.dataSource?.books[key]
        detailController.selectedArray = selectedArray!
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

