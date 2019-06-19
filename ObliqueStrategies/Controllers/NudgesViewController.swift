//
//  NudgesViewController.swift
//  ObliqueStrategies
//
//  Created by Anton C on 03/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NudgesViewController: UIViewController, GADInterstitialDelegate {
    
    var favoriteNudge: Bool = false
    
    let launchedBefore = savedUserData.bool(forKey: "launchedBefore")
    
    var interstitial: GADInterstitial?
    
    @IBOutlet weak var nudgeTextLabel: UILabel!
    @IBOutlet weak var shakeOrSwipeLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkThemeMode()
        
        if shakeOrSwipeLabel != nil {
        
            shakeOrSwipeLabel.blink()
            shakeOrSwipeLabel.flow()
            
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        nudgeTextLabel.text = ""
        favoritesList = savedUserData.stringArray(forKey: "favoritesListKey") ?? []
        
        self.becomeFirstResponder()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        selectedNudgesArray.removeAll()
        
        checkIfLaunchedBeforeAndSetNudgesLanguage()
        
        nudgesArray.shuffle()
    }
    
    func chooseAssignRandomNudge() {
        
        if nudgesArray.isEmpty {
            nudgesArray = nudgesArrayReserve
        } else {
            randomNudge = nudgesArray.randomElement()!
            selectedNudgesArray.append(randomNudge)
            let indexOfRandomNudge = nudgesArray.firstIndex(of: randomNudge)
            nudgesArray.remove(at: indexOfRandomNudge!)
            nudgeTextLabel.nudgeTransition(0.8)
            nudgeTextLabel.text = randomNudge
            
            if favoritesList.contains(randomNudge) {
                navigationItem.leftBarButtonItem?.image = UIImage(named: "AddToFavoritesFilled")
            } else {
                navigationItem.leftBarButtonItem?.image = UIImage(named: "AddToFavoritesClean")
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        if favoritesList.contains(randomNudge) {
            navigationItem.leftBarButtonItem?.image = UIImage(named: "AddToFavoritesClean")
            guard let selectedNudgeIndex = favoritesList.firstIndex(of: randomNudge) else { return }
            favoritesList.remove(at: selectedNudgeIndex)
        } else {
            navigationItem.leftBarButtonItem?.image = UIImage(named: "AddToFavoritesFilled")
            favoritesList.append(randomNudge)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        let activityViewController = UIActivityViewController(activityItems: [randomNudge], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        chooseAssignRandomNudge()
//    }
    
    override var canBecomeFirstResponder: Bool {
        
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            
            chooseAssignRandomNudge()
            
            if shakeOrSwipeLabel != nil {
                shakeOrSwipeLabel.fadeAnimation(0.8)
                shakeOrSwipeLabel.perform(#selector(shakeOrSwipeLabel.removeFromSuperview), with: nil, afterDelay: 0.8)
                navigationItem.leftBarButtonItem?.isEnabled = true
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.impactOccurred()
            
            if selectedNudgesArray.count >= 7 {
                if savedUserData.bool(forKey: "Purchased") == false {
                    interstitial = createAndLoadInterstitial()
                    selectedNudgesArray.removeAll()
                }
            }
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            
            case UISwipeGestureRecognizer.Direction.left:
                
                chooseAssignRandomNudge()
                
                if shakeOrSwipeLabel != nil {
                    shakeOrSwipeLabel.fadeAnimation(0.8)
                    shakeOrSwipeLabel.perform(#selector(shakeOrSwipeLabel.removeFromSuperview), with: nil, afterDelay: 0.8)
                    navigationItem.leftBarButtonItem?.isEnabled = true
                    navigationItem.rightBarButtonItem?.isEnabled = true
                }
                
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                feedbackGenerator.impactOccurred()
                
                if selectedNudgesArray.count >= 7 {
                    if savedUserData.bool(forKey: "Purchased") == false {
                        interstitial = createAndLoadInterstitial()
                        selectedNudgesArray.removeAll()
                    }
                }

            default:
                break
            }
        }
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        
//        Test interstitial
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        antvcl interstitial
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1042229917638554/4068378694")
        
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        request.testDevices = [ "a59e5d7144d0885ccccdc42e380b2c01" ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    func checkIfLaunchedBeforeAndSetNudgesLanguage() {
        
        if launchedBefore {
            
            switch savedUserData.stringArray(forKey: "NudgesLanguages") {
                
            case ["fr"]:
                nudgesArray = nudgesArrayFr
                nudgesArrayReserve = nudgesArrayFr
            
            case ["ru"]:
                nudgesArray = nudgesArrayRu
                nudgesArrayReserve = nudgesArrayRu
            
            case ["uk"]:
                nudgesArray = nudgesArrayUk
                nudgesArrayReserve = nudgesArrayUk
            
            default:
                nudgesArray = nudgesArrayEn
                nudgesArrayReserve = nudgesArrayEn
            }
        } else {
            
            savedUserData.set(true, forKey: "launchedBefore")
            
            switch savedUserData.stringArray(forKey: "AppleLanguages") {
                
            case ["fr"]:
                nudgesArray = nudgesArrayFr
                nudgesArrayReserve = nudgesArrayFr
                savedUserData.set(["fr"], forKey: "NudgesLanguages")
            
            case ["ru"]:
                nudgesArray = nudgesArrayRu
                nudgesArrayReserve = nudgesArrayRu
                savedUserData.set(["ru"], forKey: "NudgesLanguages")
                
            case ["uk"]:
                nudgesArray = nudgesArrayUk
                nudgesArrayReserve = nudgesArrayUk
                savedUserData.set(["uk"], forKey: "NudgesLanguages")
                
            default:
                nudgesArray = nudgesArrayEn
                nudgesArrayReserve = nudgesArrayEn
                savedUserData.set(["en"], forKey: "NudgesLanguages")
            }
        }
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
            nudgeTextLabel.textColor = textColor
            
            if shakeOrSwipeLabel != nil {
                shakeOrSwipeLabel.textColor = textColor
            }
            
        } else {
            viewColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            elementsColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            
            navigationController?.navigationBar.barStyle = UIBarStyle.default
            tabBarController?.tabBar.barStyle = .default
            navigationController?.navigationBar.tintColor = elementsColor
            tabBarController?.tabBar.tintColor = elementsColor
            self.view.backgroundColor = #colorLiteral(red: 0.932598412, green: 0.937171638, blue: 0.9544484019, alpha: 1)
            nudgeTextLabel.textColor = textColor
            
            if shakeOrSwipeLabel != nil {
                shakeOrSwipeLabel.textColor = textColor
            }
        }
        self.view.layoutIfNeeded()
    }

}

extension UIView {
    
    func nudgeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromRight
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension NudgesViewController {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
        print("Fail to receive interstitial")
    }
}

