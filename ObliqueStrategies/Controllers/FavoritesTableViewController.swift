//
//  FavoritesTableViewController.swift
//  ObliqueStrategies
//
//  Created by Anton C on 03/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FavoritesTableViewController: UITableViewController, GADBannerViewDelegate {
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        
//        Test banner
//        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        antvcl banner
        adBannerView.adUnitID = "ca-app-pub-1042229917638554/3627672795"
        
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        checkThemeMode()
        if favoritesList.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        let adRequest = GADRequest()
        adRequest.testDevices = [ "a59e5d7144d0885ccccdc42e380b2c01" ]
        
        if savedUserData.bool(forKey: "Purchased") == false {
            adBannerView.load(GADRequest())
        } else {
            tableView.tableHeaderView?.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = NSLocalizedString("Favorites", comment: "Favorites")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoritesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        cell.textLabel?.text = favoritesList[indexPath.row]
        
        if savedUserData.bool(forKey: "lightTheme") == false {
            cell.textLabel?.textColor = .white
            cell.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.07843137255, alpha: 1)
        } else {
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SelectedFavoriteNudge") as? FavoriteNudgeViewController
        nextViewController?.selectedFavoriteNudgeText = favoritesList[indexPath.row]
        
        guard nextViewController != nil else {
            return
        }
        
        navigationController?.pushViewController(nextViewController!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            favoritesList.firstIndex(of: favoritesList[indexPath.row]).map { favoritesList.remove(at: $0) }
            tableView.deleteRows(at: [indexPath], with: .fade)
            if favoritesList.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        return adBannerView.frame.height
//    }
    
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
            tableView.separatorColor = .lightGray
            
        }
        tableView.reloadData()
    }
}

extension FavoritesTableViewController {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        print("Banner loaded successfully")
        
        tableView.tableHeaderView?.frame = bannerView.frame
        tableView.tableHeaderView = bannerView
        
//        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
//        bannerView.transform = translateTransform
//
//        UIView.animate(withDuration: 0.5) {
//            bannerView.transform = CGAffineTransform.identity
//        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        print("Fail to receive ads")
        print(error)
    }
}
