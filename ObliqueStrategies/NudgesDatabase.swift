//
//  NudgesDatabase.swift
//  ObliqueStrategies
//
//  Created by Anton C on 03/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import Foundation
import UIKit

var randomNudge = ""

let savedUserData = UserDefaults.standard
let savedUserDataForWidget = UserDefaults(suiteName: "group.sharingForCleverStrategiesWidget")

var favoritesList: [String] = []

var viewColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
var textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
var elementsColor = #colorLiteral(red: 0.9529411765, green: 0.7647058824, blue: 0.3490196078, alpha: 1)
var cellColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.07843137255, alpha: 1)

public struct removeAdsPurchase {
    
    public static let removeAds = "com.az.os.removeads"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [removeAdsPurchase.removeAds]
    
    public static let store = RemoveAdsHelper(productIds: removeAdsPurchase.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

var nudgesArray = [""]

var nudgesArrayReserve = [""]

var selectedNudgesArray = [""]

var nudgesArrayEn = [
    "(Organic) machinery",
    "A line has two sides"
]

var nudgesArrayFr = [
    "Machinerie (organique)",
    "Une ligne a deux côtés"
]

var nudgesArrayRu = [
    "Действуй последовательно",
    "У отрезка два конца"
]

var nudgesArrayUk = [
    "Дій послідовно",
    "Одна лінія має дві сторони"
]
