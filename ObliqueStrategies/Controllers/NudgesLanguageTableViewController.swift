//
//  NudgesLanguageTableViewController.swift
//  ObliqueStrategies
//
//  Created by Anton C on 04/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import UIKit

class NudgesLanguageTableViewController: UITableViewController {

    @IBOutlet weak var englishLanguageCell: UITableViewCell!
    @IBOutlet weak var russianLanguageCell: UITableViewCell!
    @IBOutlet weak var ukrainianLanguageCell: UITableViewCell!
    @IBOutlet weak var frenchLanguageCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkThemeMode()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = NSLocalizedString("Cards Language", comment: "Cards Language")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        switch indexPath.row {
            
            case 0:
                savedUserData.set(["en"], forKey: "NudgesLanguages")
            
                let alertEn = UIAlertController(title: "", message: "The changes will take effect after relauching the app", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in }
                alertEn.addAction(okAction)
                present(alertEn, animated: true, completion: nil)
            
            case 1:
                savedUserData.set(["fr"], forKey: "NudgesLanguages")
            
                let alertUk = UIAlertController(title: "", message: "Les changements prendront effet après le redémarrage de l’application", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in }
                alertUk.addAction(okAction)
                present(alertUk, animated: true, completion: nil)
            
            case 2:
                savedUserData.set(["ru"], forKey: "NudgesLanguages")
            
                let alertRu = UIAlertController(title: "", message: "Изменения вступят в силу после перезапуска приложения", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in }
                alertRu.addAction(okAction)
                present(alertRu, animated: true, completion: nil)
            
            case 3:
                savedUserData.set(["uk"], forKey: "NudgesLanguages")
            
                let alertUk = UIAlertController(title: "", message: "Зміни наберуть чинності після перезапуску додатку", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in }
                alertUk.addAction(okAction)
                present(alertUk, animated: true, completion: nil)
            
            default:
                break
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
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
            
            englishLanguageCell.textLabel?.textColor = textColor
            englishLanguageCell.detailTextLabel?.textColor = textColor
            englishLanguageCell.tintColor = .white
            englishLanguageCell.backgroundColor = cellColor
            
            russianLanguageCell.textLabel?.textColor = textColor
            russianLanguageCell.detailTextLabel?.textColor = textColor
            russianLanguageCell.tintColor = .white
            russianLanguageCell.backgroundColor = cellColor
            
            ukrainianLanguageCell.textLabel?.textColor = textColor
            ukrainianLanguageCell.detailTextLabel?.textColor = textColor
            ukrainianLanguageCell.tintColor = .white
            ukrainianLanguageCell.backgroundColor = cellColor
            
            frenchLanguageCell.textLabel?.textColor = textColor
            frenchLanguageCell.detailTextLabel?.textColor = textColor
            frenchLanguageCell.tintColor = .white
            frenchLanguageCell.backgroundColor = cellColor
            
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
            
            englishLanguageCell.textLabel?.textColor = textColor
            englishLanguageCell.detailTextLabel?.textColor = textColor
            englishLanguageCell.tintColor = .black
            englishLanguageCell.backgroundColor = viewColor
            
            russianLanguageCell.textLabel?.textColor = textColor
            russianLanguageCell.detailTextLabel?.textColor = textColor
            russianLanguageCell.tintColor = .black
            russianLanguageCell.backgroundColor = viewColor
            
            ukrainianLanguageCell.textLabel?.textColor = textColor
            ukrainianLanguageCell.detailTextLabel?.textColor = textColor
            ukrainianLanguageCell.tintColor = .black
            ukrainianLanguageCell.backgroundColor = viewColor
            
            frenchLanguageCell.textLabel?.textColor = textColor
            frenchLanguageCell.detailTextLabel?.textColor = textColor
            frenchLanguageCell.tintColor = .black
            frenchLanguageCell.backgroundColor = viewColor
            
            tableView.separatorColor = .lightGray
        }
        tableView.reloadData()
    }
}
