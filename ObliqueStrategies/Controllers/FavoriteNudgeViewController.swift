//
//  FavoriteNudgeViewController.swift
//  ObliqueStrategies
//
//  Created by Anton C on 04/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import UIKit

class FavoriteNudgeViewController: UIViewController {
    
    @IBOutlet weak var favoriteNudgeTextLabel: UILabel!
    
    var selectedFavoriteNudgeText : String?
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkThemeMode()
        favoriteNudgeTextLabel.text = selectedFavoriteNudgeText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
    }
    
    @objc func shareButtonTapped() {
        let activityViewControllerFavorite = UIActivityViewController(activityItems: [selectedFavoriteNudgeText as Any], applicationActivities: nil)
        present(activityViewControllerFavorite, animated: true, completion: nil)
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
            self.view.backgroundColor = viewColor
            favoriteNudgeTextLabel.textColor = textColor
            
        } else {
            viewColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            elementsColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
            navigationController?.navigationBar.barStyle = UIBarStyle.default
            tabBarController?.tabBar.barStyle = .default
            navigationController?.navigationBar.tintColor = elementsColor
            tabBarController?.tabBar.tintColor = elementsColor
            self.view.backgroundColor = #colorLiteral(red: 0.932598412, green: 0.937171638, blue: 0.9544484019, alpha: 1)
            favoriteNudgeTextLabel.textColor = textColor
        }
        self.view.layoutIfNeeded()
    }
}
