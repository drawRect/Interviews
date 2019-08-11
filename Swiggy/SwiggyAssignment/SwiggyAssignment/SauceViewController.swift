//
//  SauceViewController.swift
//  SwiggyAssignment
//
//  Created by Ranjith Kumar on 3/16/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import UIKit

class SauceViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: VariantCell.identifier, bundle: nil), forCellReuseIdentifier: VariantCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }

    var response:JSONResponse?
    var handPickedCrust: Variation!
    var handPickedSize: Variation!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick your Sauce"
    }

}

extension SauceViewController: UITableViewDataSource,UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.variants.variantGroups.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  VariantCell.identifier, for: indexPath) as? VariantCell else {fatalError("Incompatible cell")}
        let variantGroup = response?.variants.variantGroups[2]
        let variantion = variantGroup?.variations[indexPath.row]
        cell.variantion = variantion
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let holderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-20, height: 45))
            holderView.backgroundColor = .white
            let label = UILabel(frame: CGRect(x:30,y:15,width:100,height:45))
            label.text = response?.variants.variantGroups[2].name
            label.font = UIFont.boldSystemFont(ofSize: 19.0)
            label.sizeToFit()
            holderView.addSubview(label)
            return label
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let variantGroup = response?.variants.variantGroups[2]
        let selected = variantGroup?.variations[indexPath.row]
        let totalPrice = handPickedCrust.price + handPickedSize.price + (selected?.price ?? 0)

        let alertController = UIAlertController(title: "Confirm your order Details?", message: "Crust:\(handPickedCrust.name)(Rs.\(handPickedCrust.price))\nSize:\(handPickedSize.name)(Rs.\(handPickedSize.price))\nSauce:\(selected?.name ?? "")(Rs.\(selected!.price))\nTotal Price:\(totalPrice)", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let okayAction = UIAlertAction(title: "Order", style: .default) { (didTapOK) in
            DispatchQueue.main.async {
                self.perform(#selector(self.showOrder), with: nil, afterDelay: 0.1)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)

    }

    @objc private func showOrder() {
        let alertController = UIAlertController(title: "Thank you!", message: "Your order has been successfully placed", preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "Okay", style: .default) { (didTapOK) in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
