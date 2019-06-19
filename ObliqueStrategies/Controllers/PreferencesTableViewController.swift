//
//  PreferencesTableViewController.swift
//  ObliqueStrategies
//
//  Created by Anton C on 03/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import UIKit
import StoreKit

class PreferencesTableViewController: UITableViewController {
    
    @IBOutlet weak var appLanguageCell: UITableViewCell!
    @IBOutlet weak var nudgesLanguageCell: UITableViewCell!
    @IBOutlet weak var nudgesLanguageLabel: UILabel!
    @IBOutlet weak var removeAdsCell: UITableViewCell!
    @IBOutlet weak var lightThemeModeCell: UITableViewCell!
    @IBOutlet weak var aboutCell: UITableViewCell!
    
    let lightThemeModeSwitch = UISwitch()
    
    var products: [SKProduct] = []
    
    var removeAdsProduct: SKProduct? {
        didSet {
//            guard let product = removeAdsProduct else { return }
            
            if RemoveAdsHelper.canMakePayments() {
                print("can make payments")
            } else {
                removeAdsCell.textLabel?.text = "Not Available"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lightThemeModeSwitch.isOn = savedUserData.bool(forKey: "lightTheme")
        checkThemeMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Preferences", comment: "Preferences")
        
        lightThemeModeCell?.accessoryView = lightThemeModeSwitch
        lightThemeModeSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PreferencesTableViewController.handlePurchaseNotification(_:)),
                                               name: .RemoveAdsHelperPurchaseNotification,
                                               object: nil)
        
        checkSetNudgesLanguageLabel()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        if savedUserData.bool(forKey: "Purchased") {
            return 4
        } else {
            return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
            
        case [4, 0]:
            
            reload()
            
            let alertRemoveAds = UIAlertController(title: NSLocalizedString("REMOVE ADS", comment: "Remove Ads"), message: "", preferredStyle: .alert)
            let purchaseAction = UIAlertAction(title: NSLocalizedString("Make a purchase", comment: "Make a purchase"), style: .default) { (action: UIAlertAction) in if self.products.isEmpty == false {
                removeAdsPurchase.store.buyProduct(self.products.first!)}}
            let restoreAction = UIAlertAction(title: NSLocalizedString("Restore", comment: "Restore"), style: .default) { (action: UIAlertAction) in
                removeAdsPurchase.store.delegate = self
                removeAdsPurchase.store.restorePurchases()}
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (action: UIAlertAction) in }
            
            alertRemoveAds.addAction(purchaseAction)
            alertRemoveAds.addAction(restoreAction)
            alertRemoveAds.addAction(cancelAction)
            
            present(alertRemoveAds, animated: true, completion: nil)
        
        default:
            break
        }
    }
    
    @objc func switchValueDidChange() {
        if lightThemeModeSwitch.isOn == true {
            savedUserData.set(true, forKey: "lightTheme")
            checkThemeMode()
        } else {
            savedUserData.set(false, forKey: "lightTheme")
            checkThemeMode()
        }
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        
        guard let productID = notification.object as? String,
              let index = products.firstIndex(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        
        tableView.reloadData()
    }
    
    @objc func reload() {
        
        products = []
        
        removeAdsPurchase.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
            }
        }
    }
    
    func checkSetNudgesLanguageLabel() {
        
        switch savedUserData.stringArray(forKey: "NudgesLanguages") {
            
        case ["en"]:
            nudgesLanguageLabel.text = "English"
        case ["fr"]:
            nudgesLanguageLabel.text = "Français"
        case ["it"]:
            nudgesLanguageLabel.text = "Italiano"
        case ["ru"]:
            nudgesLanguageLabel.text = "Русский"
        case ["uk"]:
            nudgesLanguageLabel.text = "Українська"
        default:
            break
        }
    }
    
    func checkThemeMode() {
        
        if savedUserData.bool(forKey: "lightTheme") == false {
            
            viewColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            elementsColor = #colorLiteral(red: 0.9529411765, green: 0.7647058824, blue: 0.3490196078, alpha: 1)
            cellColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.07843137255, alpha: 1)
            
            navigationController?.navigationBar.barStyle = UIBarStyle.black
            tabBarController?.tabBar.barStyle = .black
            navigationController?.navigationBar.tintColor = elementsColor
            tabBarController?.tabBar.tintColor = elementsColor
            tableView.backgroundColor = viewColor
            
            appLanguageCell.textLabel?.textColor = .white
            appLanguageCell.detailTextLabel?.textColor = .lightGray
            appLanguageCell.tintColor = .white
            appLanguageCell.backgroundColor = cellColor
            
            nudgesLanguageCell.textLabel?.textColor = .white
            nudgesLanguageCell.detailTextLabel?.textColor = .lightGray
            nudgesLanguageCell.tintColor = .white
            nudgesLanguageCell.backgroundColor = cellColor
            
            lightThemeModeCell.textLabel?.textColor = .white
            lightThemeModeCell.tintColor = .white
            lightThemeModeCell.backgroundColor = cellColor
            
            aboutCell.textLabel?.textColor = .white
            aboutCell.tintColor = .white
            aboutCell.backgroundColor = cellColor
            
            removeAdsCell.textLabel?.textColor = elementsColor
            removeAdsCell.backgroundColor = cellColor
            
            tableView.separatorColor = #colorLiteral(red: 0.1537629068, green: 0.148864001, blue: 0.1489192247, alpha: 1)
            
        } else {
            
            viewColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            elementsColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
            navigationController?.navigationBar.barStyle = UIBarStyle.default
            tabBarController?.tabBar.barStyle = .default
            navigationController?.navigationBar.tintColor = elementsColor
            tabBarController?.tabBar.tintColor = elementsColor
            tableView.backgroundColor = #colorLiteral(red: 0.932598412, green: 0.937171638, blue: 0.9544484019, alpha: 1)
            
            appLanguageCell.textLabel?.textColor = .black
            appLanguageCell.detailTextLabel?.textColor = .darkGray
            appLanguageCell.tintColor = .black
            appLanguageCell.backgroundColor = viewColor
            
            nudgesLanguageCell.textLabel?.textColor = .black
            nudgesLanguageCell.detailTextLabel?.textColor = .darkGray
            nudgesLanguageCell.tintColor = .black
            nudgesLanguageCell.backgroundColor = viewColor
            
            lightThemeModeCell.textLabel?.textColor = .black
            lightThemeModeCell.tintColor = .black
            lightThemeModeCell.backgroundColor = viewColor
            
            aboutCell.textLabel?.textColor = .black
            aboutCell.tintColor = .black
            aboutCell.backgroundColor = viewColor
            
            removeAdsCell.textLabel?.textColor = elementsColor
            removeAdsCell.backgroundColor = viewColor
            
            tableView.separatorColor = .lightGray
        }
        tableView.reloadData()
    }
}

extension UIActivityIndicatorView {
    func makeLargeGray() {
        style = .whiteLarge
        color = .lightGray
    }
}

extension PreferencesTableViewController: CompletedFaildAlerts {
    
    func presentRestoreAlert() {
        
        let restoredAlert = UIAlertController(title: NSLocalizedString("You're all set", comment: "You're all set"), message: NSLocalizedString("Purchase successfully restored.", comment: "Purchase successfully restored."), preferredStyle: .alert)
        let restoredAlertAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in }
        restoredAlert.addAction(restoredAlertAction)
        
        tableView.reloadData()
        present(restoredAlert, animated: true, completion: nil)
    }
    
    func presentCompleteAlert() {
        
        let completedAlert = UIAlertController(title: NSLocalizedString("You're all set", comment: "You're all set"), message: NSLocalizedString("Your purchase was successfull.", comment: "Your purchase was successfull."), preferredStyle: .alert)
        let completedAlertAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in }
        completedAlert.addAction(completedAlertAction)
        
        tableView.reloadData()
        present(completedAlert, animated: true, completion: nil)
    }
    
    func presentFailAlert() {
        
        let failAlert = UIAlertController(title: NSLocalizedString("Something went wrong...", comment: "Something went wrong..."), message: "", preferredStyle: .alert)
        let failAlertAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in }
        failAlert.addAction(failAlertAction)
        
        tableView.reloadData()
        present(failAlert, animated: true, completion: nil)
    }
}
