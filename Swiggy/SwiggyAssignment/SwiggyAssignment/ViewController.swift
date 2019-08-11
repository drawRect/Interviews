//
//  ViewController.swift
//  SwiggyAssignment
//
//  Created by Ranjith Kumar on 3/16/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: VariantCell.identifier, bundle: nil), forCellReuseIdentifier: VariantCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }

    var response:JSONResponse?

    lazy var blurredView: UIView = {
        let v = UIView(frame: view.bounds)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.center = v.center
        activityIndicator.startAnimating()
        v.addSubview(activityIndicator)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swiggy-Assignment"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if response == nil {
            view.addSubview(blurredView)
            getJSONResponse()
        }
    }

    private func getJSONResponse() {
        APIClient.getJSONReponse { (result) in
            DispatchQueue.main.async {[weak self] in
                self?.blurredView.removeFromSuperview()
            }
            switch(result) {
            case .success(let value):
                DispatchQueue.main.async {[weak self] in
                    self?.response = value
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error:\(error)")
            }
        }
    }

}

extension ViewController: UITableViewDataSource,UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.variants.variantGroups.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  VariantCell.identifier, for: indexPath) as? VariantCell else {fatalError("Incompatible cell")}
        let variantGroup = response?.variants.variantGroups[0]
        let variantion = variantGroup?.variations[indexPath.row]
        cell.variantion = variantion
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let holderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-20, height: 45))
            holderView.backgroundColor = .white
            let label = UILabel(frame: CGRect(x:30,y:15,width:100,height:45))
            label.text = response?.variants.variantGroups[section].name
            label.font = UIFont.boldSystemFont(ofSize: 19.0)
            label.sizeToFit()
            holderView.addSubview(label)
            return label
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sizeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SizeViewController") as! SizeViewController
        sizeViewController.response = response
        let variantGroup = response?.variants.variantGroups[0]
        let selected = variantGroup?.variations[indexPath.row]
        sizeViewController.handPickedCrust = selected
        self.navigationController?.pushViewController(sizeViewController, animated: true)
    }
}

