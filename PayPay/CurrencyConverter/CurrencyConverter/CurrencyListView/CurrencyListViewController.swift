//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 07/03/23.
//

import UIKit

final class CurrencyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CurrencyListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currencies"
        configureTableView()
        
        viewModel.loadCurrenyList()
        
        viewModel.completion = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyTableViewCell")
    }
}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        let currency = viewModel.cellForItemAt(indexPath: indexPath)
        cell.configure(currency: currency)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNotSupportedAlert()
    }
    
    private func showNotSupportedAlert() {
        let alertController = UIAlertController(title: "Currency Converter", message: "We are supporting only 'USD Dollar' now.", preferredStyle: .alert)
         let okayAction = UIAlertAction(title: "OK", style: .cancel)
         alertController.addAction(okayAction)
         self.present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
