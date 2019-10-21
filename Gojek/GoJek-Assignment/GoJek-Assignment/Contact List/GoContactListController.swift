//
//  ViewController.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 11/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import UIKit

class GoContactsListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(GoContactListCell.nib, forCellReuseIdentifier: GoContactListCell.reuseIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.sectionIndexColor = UIColor.lightGray
            tableView.tableFooterView = UIView()
        }
    }
    
    lazy var toastView: UIAlertController = {
        return UIAlertController(title: "No Functionality", message: "Have to Implement :)", preferredStyle: .alert)
    }()
    var contacts:GoContacts = GoContacts()
    lazy var loadingHUD:ProgressHUD = ProgressHUD(text: "Loading...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact"
        self.view.addSubview(loadingHUD)
        
        self.addLeftNRightBarButtons()
        self.getContacts()

        NotificationCenter.default.addObserver(self, selector: #selector(didChangeContact), name: NSNotification.Name(rawValue: "contact.changes"), object: nil)
    }

    @objc private func didChangeContact(notification:NSNotification) {
        let recievedObject = notification.object as! GoContact
        let char = recievedObject.firstName.first!
        let charString = String(char).uppercased()
        guard let list = contacts.orderedPeople[charString] else {
            contacts.orderedPeople[charString] = [recievedObject]
            return
        }
        var nonMatches = list.filter({$0.id != recievedObject.id})
        nonMatches.insert(recievedObject, at: 0)
        contacts.orderedPeople[charString] = nonMatches
        self.tableView.reloadData()
    }

    private func getContacts() {
        self.loadingHUD.show()
        GoNetworkHelper.fetchContactsList { (result) in
            DispatchQueue.main.async {
                self.loadingHUD.hide()
            }
            switch result {
            case .success(let contacts):
                DispatchQueue.main.async {
                    self.contacts = contacts
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error on \(#function):\(error)")
            }
        }
    }
    
    private func addLeftNRightBarButtons() {
        let groupsBarBtn = UIBarButtonItem(title: "Groups", style: .done, target: self, action: #selector(didTapGroupsBtn))
        groupsBarBtn.tintColor = GoConstants.themeColor
        self.navigationItem.leftBarButtonItem = groupsBarBtn
        
        let addCntBarBtn = UIBarButtonItem(image: UIImage(named: "plus_button"), style: .done, target: self, action: #selector(didTapAddContactBtn))
        addCntBarBtn.tintColor = GoConstants.themeColor
        self.navigationItem.rightBarButtonItem = addCntBarBtn
    }
    
    @objc private func didTapGroupsBtn() {
        self.present(toastView, animated: true) {
            self.perform(#selector(self.dismissToast), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func dismissToast() {
        self.toastView.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAddContactBtn() {
        guard let editController = self.storyboard?.instantiateViewController(withIdentifier: GoContactEditController.identifier) as? GoContactEditController else {fatalError()}
        editController.displayType = .add
        editController.delegate = self
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
}

extension GoContactsListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contacts.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.listOnIndexPath(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GoContactListCell.reuseIdentifier, for: indexPath) as? GoContactListCell else {fatalError("Expected GoContactListCell")}
        let contact = self.contacts.contactOnRow(indexPath: indexPath)
        cell.profileNameLbl.text = contact.name
        cell.profileImageVew.setImage(url: GoNetworkHelper.baseURL+contact.profilePic, style: .rounded, completion: nil)
        if contact.favorite {
            cell.favBtn.isHidden = false
            cell.favBtn.setImage(UIImage(named: "home_favourite"), for: .normal)
        }else {
            cell.favBtn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.contacts.sections[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.contacts.sections
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contactDetailsController = self.storyboard?.instantiateViewController(withIdentifier: GoContactDetailsController.identifier) as? GoContactDetailsController else {fatalError()}
        contactDetailsController.delegate = self
        contactDetailsController.contact = self.contacts.contactOnRow(indexPath: indexPath)
        self.navigationController?.pushViewController(contactDetailsController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension GoContactsListController: ContactDeleteProtocol {
    func didDelete(contact: GoContact) {
        guard let char = contact.firstName.first else{return}
        let charString = String(char).uppercased()
        guard var list = contacts.orderedPeople[charString] else {return}
        list.removeAll(where: { (cnt) -> Bool in
            return cnt.id == contact.id
        })
        contacts.orderedPeople[charString] = list
        self.tableView.reloadData()
    }
}

extension GoContactsListController: ContactCreateProtocol {
    func didCreate(contact: GoContact) {
        let char = contact.firstName.first!
        let charString = String(char).uppercased()
        guard var list = contacts.orderedPeople[charString] else {
            contacts.orderedPeople[charString] = [contact]
            return
        }
        list.insert(contact, at: 0)
        contacts.orderedPeople[charString] = list
        self.tableView.reloadData()
    }
}
