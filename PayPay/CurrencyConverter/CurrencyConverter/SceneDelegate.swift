//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    private var mainStoryboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
    private var currencyViewController: CurrencyViewController {
        let currencyViewController = CurrencyViewController.instantiateFromStoryboard()
        let currencyViewModel = CurrencyViewModel()
        currencyViewModel.delegate = currencyViewController
        currencyViewController.viewModel = currencyViewModel
        return currencyViewController
    }
    private var rootViewController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: currencyViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
}

