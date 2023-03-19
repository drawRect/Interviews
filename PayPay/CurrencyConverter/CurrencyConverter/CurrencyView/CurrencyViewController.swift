//
//  CurrencyViewController.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

import UIKit

final class CurrencyViewController: UIViewController {
    
    @IBOutlet private weak var inputTextField: UITextField! {
        didSet {
            inputTextField.keyboardType = .numberPad
            inputTextField.delegate = self
            inputTextField.adjustsFontSizeToFitWidth = true
            inputTextField.addTarget(
                self,
                action: #selector(CurrencyViewController.textFieldDidChange(_:)),
                for: .editingChanged
            )
        }
    }
    
    @IBOutlet private weak var outputLabel: UILabel! {
        didSet {
            outputLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet private weak var baseCurrencyBtn: UIButton! {
        didSet {
            baseCurrencyBtn.titleLabel?.font =  .systemFont(ofSize: 22, weight: .semibold)
            baseCurrencyBtn.backgroundColor = .clear
            baseCurrencyBtn.layer.cornerRadius = 5
            baseCurrencyBtn.layer.borderWidth = 1
            baseCurrencyBtn.layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.collectionViewLayout = flowLayout
            collectionView.keyboardDismissMode = .onDrag
            collectionView.registerNib(with: "CurrencyViewCollectionViewCell")
        }
    }
    
    var viewModel: CurrencyViewModel!
    
    private var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width/3,
            height: UIScreen.main.bounds.width/3
        )
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency Converter"
                
        viewModel.loadCurrencyRatesIfValid()
    }
    
    private func reloadData() {
        collectionView.reloadData()
    }
    
    private func clearInputFieldAndEnableKeyboard() {
        inputTextField.text = ""
        inputTextField.becomeFirstResponder()
    }
    
    @IBAction func didTapBaseCurrency(_ sender: Any) {
        let currencyListVC = CurrencyListViewController.instantiateFromStoryboard()
        currencyListVC.viewModel = CurrencyListViewModel()
        navigationController?.pushViewController(currencyListVC, animated: true)
    }
    
    var inputValue: Double {
        guard let txt = inputTextField.text,
              let value = Double(txt) else {
            return 0.0
        }
        return value
    }
    
    func showAlertOn(error: NetworkError) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true)
        }
    }
    
}

extension CurrencyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCurrencies()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(cellClass: CurrencyViewCollectionViewCell.self, indexPath: indexPath)
        cell.configure(currency: viewModel.get(index: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.chooseNewCurrency(at: indexPath.row)
    }
    
}

extension CurrencyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthByThree = collectionView.bounds.width/3.0
        return CGSize(width: widthByThree, height: widthByThree)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension CurrencyViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard viewModel.numberOfCurrencies() > 0 else {
            return
        }
        viewModel.convert(inputValue)
    }
}

extension CurrencyViewController: CurrencyViewModifier {
    func currencyLoaded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.reloadData()
            self.viewModel.set(symbol: self.viewModel.phoneCurrencyCode)
            self.clearInputFieldAndEnableKeyboard()
        }
    }
    
    func scrollCollectionViewAt(index: Int) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
    }
    
    func update(_ output: String) {
        outputLabel.text = output
    }
    
    func reload(items: [Int]) {
        if viewModel.numberOfCurrencies() == 0 {
            return
        }
        let indexPaths = items.map{IndexPath(row: $0, section: 0)}
        collectionView.reloadItems(at: indexPaths)
        viewModel.convert(inputValue)
    }
}
