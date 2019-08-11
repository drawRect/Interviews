//
//  SizeViewController.swift
//  SwiggyAssignment
//
//  Created by Ranjith Kumar on 3/16/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import UIKit

class SizeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: VariantCell.identifier, bundle: nil), forCellReuseIdentifier: VariantCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }

    var response:JSONResponse?
    var handPickedCrust:Variation!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick your Size"
    }

}

extension SizeViewController: UITableViewDataSource,UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.variants.variantGroups.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  VariantCell.identifier, for: indexPath) as? VariantCell else {fatalError("Incompatible cell")}
        let variantGroup = response?.variants.variantGroups[1]
        let variantion = variantGroup?.variations[indexPath.row]
        cell.variantion = variantion
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let holderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-20, height: 45))
            holderView.backgroundColor = .white
            let label = UILabel(frame: CGRect(x:30,y:15,width:100,height:45))
            label.text = response?.variants.variantGroups[1].name
            label.font = UIFont.boldSystemFont(ofSize: 19.0)
            label.sizeToFit()
            holderView.addSubview(label)
            return label
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sauceViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SauceViewController") as! SauceViewController
        sauceViewController.response = response
        sauceViewController.handPickedCrust = handPickedCrust
        let variantGroup = response?.variants.variantGroups[1]
        let selected = variantGroup?.variations[indexPath.row]
        sauceViewController.handPickedSize = selected
        self.navigationController?.pushViewController(sauceViewController, animated: true)
    }
}
