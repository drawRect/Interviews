//
//  GoContactDetailsController.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import UIKit

protocol ContactDeleteProtocol: class {
    func didDelete(contact:GoContact)
}

class GoContactDetailsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(GoContactDetailCell.nib, forCellReuseIdentifier: GoContactDetailCell.reuseIdentifier)
            tableView.backgroundColor = UIColor.rgb(from: 0xd4d4d4, alpha: 0.2)
            tableView.tableFooterView = UIView()
        }
    }
    lazy var deleteView:UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 75))
        btn.backgroundColor = UIColor.white
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.setTitle("    delete", for: .normal)
        btn.addTarget(self, action: #selector(didTapDeleteBtn), for: .touchUpInside)
        return btn
    }()
    var contact:GoContact!
    weak var delegate:ContactDeleteProtocol?
    lazy var toastView: UIAlertController = {
        return UIAlertController(title: "No Functionality", message: "Have to Implement :)", preferredStyle: .alert)
    }()
    lazy var loadingHUD:ProgressHUD = ProgressHUD(text: "Loading...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRightBarBtn()
        if !self.contact.isFetchedDetails {
            self.getContactDetails()
        }
    }
    
    private func getContactDetails() {
        self.loadingHUD.show()
        GoNetworkHelper.getContactDetails(with: contact) { (result) in
            DispatchQueue.main.async {
                self.loadingHUD.hide()
            }
            switch result {
            case .success(let newData):
                DispatchQueue.main.async {
                    self.contact.firstName = newData.firstName
                    self.contact.lastName = newData.lastName
                    self.contact.email = newData.email
                    self.contact.phone = newData.phone
                    self.contact.isFetchedDetails = true
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error on \(#function):\(error)")
            }
        }
    }
    
    private func addRightBarBtn() {
        let editCntBarBtn = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(didTapEditBtn))
        editCntBarBtn.tintColor = GoConstants.themeColor
        self.navigationItem.rightBarButtonItem = editCntBarBtn
    }
    
    @objc private func didTapEditBtn() {
        guard let editController = self.storyboard?.instantiateViewController(withIdentifier: GoContactEditController.identifier) as? GoContactEditController else {fatalError()}
        editController.displayType = .edit
        editController.contact = self.contact
        editController.delegate = self
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    @objc private func didTapDeleteBtn() {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure want to delete?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteContact()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func deleteContact() {
        self.loadingHUD.show()
        GoNetworkHelper.deleteContact(with: contact) { (result) in
            DispatchQueue.main.async {
                self.loadingHUD.hide()
            }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.delegate?.didDelete(contact: self.contact)
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("Error on \(#function):\(error)")
            }
        }
    }
    
}

extension GoContactDetailsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GoContactDetailCell.reuseIdentifier, for: indexPath) as? GoContactDetailCell else {fatalError("#GoContactDetailCell")}
        cell.valueLbl.isEnabled = false
        if indexPath.row == 0 {
            cell.captionLbl.text = "mobile"
            cell.valueLbl?.text = contact.phone
        }else {
            cell.captionLbl.text = "phone"
            cell.valueLbl?.text = contact.email
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GoContactDetailsHeaderView.instanceFromNib()
        headerView.populate(contact: contact)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return deleteView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 75
    }
    
}

extension GoContactDetailsController: HeaderViewBtnActions {
    func didTapAction() {
        self.present(toastView, animated: true) {
            self.perform(#selector(self.dismissToast), with: nil, afterDelay: 0.5)
        }
    }

    func didTapFavAction() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contact.changes"), object: contact)
    }

    @objc func dismissToast() {
        self.toastView.dismiss(animated: true, completion: nil)
    }
}

extension GoContactDetailsController: ContactCreateProtocol {
    func didCreate(contact: GoContact) {
        self.contact = contact
        self.tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contact.changes"), object: contact)
    }
}
