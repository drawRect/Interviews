//
//  GoContactEditController.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import UIKit

protocol ContactCreateProtocol: class {
    func didCreate(contact: GoContact)
}

class GoContactEditController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(GoContactDetailCell.nib, forCellReuseIdentifier: GoContactDetailCell.reuseIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.keyboardDismissMode = .onDrag
        }
    }
    
    var displayType:ContactDisplayType! {
        didSet {
            if displayType == .add {
                contact = GoContact(id: 0, firstName: "", lastName: "", profilePic: "", favorite: false, url: "", phone: "", email: "", createdAt: "", updatedAt: "")
            }
        }
    }
    private(set) var displayDataSource:[DisplayContentType] = [.firstName,.lastName,.phone,.email]
    var contact:GoContact!
    lazy var toastView: UIAlertController = {
        return UIAlertController(title: "No Functionality", message: "Have to Implement :)", preferredStyle: .alert)
    }()
    lazy var loadingHUD:ProgressHUD = ProgressHUD(text: "Loading...")
    public weak var delegate:ContactCreateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftNRightBarButtons()
    }
    
    private func addLeftNRightBarButtons() {
        let cacnelBarBtn = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didtapCancelBtn))
        cacnelBarBtn.tintColor = GoConstants.themeColor
        self.navigationItem.leftBarButtonItem = cacnelBarBtn
        
        let doneBarBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didtapDoneBtn))
        doneBarBtn.tintColor = GoConstants.themeColor
        self.navigationItem.rightBarButtonItem = doneBarBtn
    }
    
    @objc private func didtapCancelBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didtapDoneBtn() {
        let fnIndexPath = IndexPath(row: DisplayContentType.firstName.index, section: 0)
        let fncell: GoContactDetailCell = self.tableView.cellForRow(at: fnIndexPath) as! GoContactDetailCell
        let lnIndexPath = IndexPath(row: DisplayContentType.lastName.index, section: 0)
        let lncell: GoContactDetailCell = self.tableView.cellForRow(at: lnIndexPath) as! GoContactDetailCell
        if (fncell.valueLbl.text?.count)! < 1 || ((lncell.valueLbl.text?.count)!) < 1 {
            let alert = UIAlertController(title: "Error", message: "First & Last Name should not be empty!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
        }else {
            let phoneIndexPath = IndexPath(row: DisplayContentType.phone.index, section: 0)
            let phonecell: GoContactDetailCell = self.tableView.cellForRow(at: phoneIndexPath) as! GoContactDetailCell
            let emailIndexPath = IndexPath(row: DisplayContentType.email.index, section: 0)
            let emailcell: GoContactDetailCell = self.tableView.cellForRow(at: emailIndexPath) as! GoContactDetailCell
            contact.firstName = fncell.valueLbl.text!
            contact.lastName = lncell.valueLbl.text!
            contact.phone = phonecell.valueLbl.text
            contact.email = emailcell.valueLbl.text

            if displayType == .add {
                contact.id = Int(Date.timeIntervalSinceReferenceDate)
                self.doCreate()
            }else {
                self.doUpdate()
            }
        }
    }
    
    func doUpdate() {
        self.loadingHUD.show()
        GoNetworkHelper.updateContact(with: contact) { (result) in
            DispatchQueue.main.async {
                self.loadingHUD.hide()
            }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.delegate?.didCreate(contact: self.contact)
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("Error on \(#function):\(error)")
            }
        }
    }
    
    func doCreate() {
        contact.profilePic = "/images/missing.png"
        contact.favorite = false
        self.loadingHUD.show()
        GoNetworkHelper.createContact(with: contact) { (result) in
            DispatchQueue.main.async {
                self.loadingHUD.hide()
            }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.delegate?.didCreate(contact: self.contact)
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("Error on \(#function):\(error)")
            }
        }
    }
}

extension GoContactEditController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GoContactDetailCell.reuseIdentifier, for: indexPath) as? GoContactDetailCell else {fatalError("Expected GoContactDetailCell")}
        switch indexPath.row {
        case DisplayContentType.firstName.index:
            cell.captionLbl.text = DisplayContentType.firstName.caption
            cell.valueLbl.text = contact.firstName
            cell.valueLbl.becomeFirstResponder()
            cell.valueLbl.keyboardType = .default
        case DisplayContentType.lastName.index:
            cell.captionLbl.text = DisplayContentType.lastName.caption
            cell.valueLbl.text = contact.lastName
            cell.valueLbl.keyboardType = .default
        case DisplayContentType.phone.index:
            cell.captionLbl.text = DisplayContentType.phone.caption
            cell.valueLbl.text = contact.phone
            cell.valueLbl.keyboardType = .numberPad
        case DisplayContentType.email.index:
            cell.captionLbl.text = DisplayContentType.email.caption
            cell.valueLbl.text = contact.email
            cell.valueLbl.keyboardType = .emailAddress
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  GoContactEditHeaderView.instanceFromNib()
        headerView.delegate = self
        if displayType == .edit {
            headerView.populate(contact: contact)
        }else {
            headerView.profileImageView.image = UIImage(named: "placeholder_photo")
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
}

extension GoContactEditController {
    enum ContactDisplayType {
        case add
        case edit
    }
    
    enum DisplayContentType {
        case firstName
        case lastName
        case phone
        case email
        
        var caption:String {
            switch self {
            case .firstName: return "first name"
            case .lastName: return "last name"
            case .phone: return "phone"
            case .email: return "email"
            }
        }
        
        var index:Int {
            switch self {
            case .firstName: return 0
            case .lastName: return 1
            case .phone: return 2
            case .email: return 3
            }
        }
    }
}

extension GoContactEditController: ProfilePicEditAction {
    func didTapAddProfilePic() {
        self.present(toastView, animated: true) {
            self.perform(#selector(self.dismissToast), with: nil, afterDelay: 0.5)
        }
    }

    @objc func dismissToast() {
        self.toastView.dismiss(animated: true, completion: nil)
    }
}
