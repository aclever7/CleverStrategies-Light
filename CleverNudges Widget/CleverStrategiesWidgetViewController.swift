//
//  TodayViewController.swift
//  CleverNudges Widget
//
//  Created by Anton C on 10/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import UIKit
import NotificationCenter

let savedUserDataForWidget = UserDefaults.init(suiteName: "group.sharingForCleverStrategiesWidget")

class CleverStrategiesWidgetViewController: UIViewController, NCWidgetProviding {
    
    let favoritesList: [String] = savedUserDataForWidget?.value(forKey: "favoritesListKeyForWidget") as! [String]
        
    @IBOutlet weak var favoriteNudgeLabel: UILabel!
    @IBOutlet weak var favoriteNudgeWidgetEffect: UIVisualEffectView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        favoriteNudgeWidgetEffect.effect = UIVibrancyEffect.widgetSecondary()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        if favoritesList.isEmpty == false {
            favoriteNudgeLabel.text = favoritesList.randomElement()
            completionHandler(NCUpdateResult.newData)
        } else {
            favoriteNudgeLabel.text = NSLocalizedString("No favorites to show", comment: "No favorites to show")
            completionHandler(NCUpdateResult.noData)
        }
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
//        completionHandler(NCUpdateResult.newData)
    }
    
}
