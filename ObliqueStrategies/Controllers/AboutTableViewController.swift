//
//  AboutTableViewController.swift
//  ObliqueStrategies
//
//  Created by Anton C on 04/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    @IBOutlet weak var aboutAppCell: UITableViewCell!
    @IBOutlet weak var aboutAppLabel: UILabel!
    @IBOutlet weak var versionAppCell: UITableViewCell!
    @IBOutlet weak var versionAppLabel: UILabel!
    
    let aboutApp = NSLocalizedString("CleverStrategies is aimed to help developers, designers, engineers and anyone who is stuck during idea evaluation process to refresh their mind and think out of the box. \n \nThis app is based on Oblique Strategies cards created by Brian Eno and Peter Schmidt in 1975 in order to boost up creativity thinking process. Since first release, these cards have been used by many creative people all over the world including Coldplay, David Bowie, Talking Heads and Devo. \n \nCleverStrategies app includes all 6 editions of time-proven Oblique Strategies cards. \nRight here. Right now. Ready to use. \n \nFor further information on the original Oblique Strategies created by Brian Eno and Peter Schmidt visit this site: \n \nhttps://www.enoshop.co.uk/product/oblique-strategies.html", comment: "About App")
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkThemeMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = NSLocalizedString("About App", comment: "About App")
        
        aboutAppLabel.text = aboutApp
        versionAppLabel.text = version()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }


    func checkThemeMode() {
        
        if savedUserData.bool(forKey: "lightTheme") == false {
            viewColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            elementsColor = #colorLiteral(red: 0.9529411765, green: 0.7647058824, blue: 0.3490196078, alpha: 1)
            
            navigationController?.navigationBar.barStyle = UIBarStyle.black
            tabBarController?.tabBar.barStyle = .black
            navigationController?.navigationBar.tintColor = elementsColor
            tabBarController?.tabBar.tintColor = elementsColor
            tableView.backgroundColor = viewColor
            
            aboutAppCell.textLabel?.textColor = textColor
            aboutAppCell.tintColor = .white
            aboutAppLabel.textColor = textColor
            
            versionAppCell.textLabel?.textColor = textColor
            versionAppCell.tintColor = .white
            versionAppLabel.textColor = textColor
            
        } else {
            
            viewColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            elementsColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
            navigationController?.navigationBar.barStyle = UIBarStyle.default
            tabBarController?.tabBar.barStyle = .default
            navigationController?.navigationBar.tintColor = elementsColor
            tabBarController?.tabBar.tintColor = elementsColor
            tableView.backgroundColor = #colorLiteral(red: 0.932598412, green: 0.937171638, blue: 0.9544484019, alpha: 1)
            
            aboutAppCell.textLabel?.textColor = textColor
            aboutAppCell.tintColor = .black
            aboutAppLabel.textColor = textColor
            
            versionAppCell.textLabel?.textColor = textColor
            versionAppCell.tintColor = .black
            versionAppLabel.textColor = textColor
        }
        tableView.reloadData()
    }
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\nv.\(version)(\(build))"
    }
}
