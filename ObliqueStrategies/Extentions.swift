//
//  Extentions.swift
//  ObliqueStrategies
//
//  Created by Anton C on 27/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func blink() {
        self.alpha = 0.0
        UIView.animate(withDuration: 2, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
    
    func flow() {
        UIView.animate(withDuration: 4, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.8, options: [.curveLinear, .repeat], animations: {self.frame.origin.x -= 60
        }, completion: nil)
        self.frame.origin.x += 60
    }
    
    func blinkFast() {
        self.alpha = 0.3
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
    
    func fadeAnimation(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {self.alpha = 0.0}, completion: nil)
    }
}

