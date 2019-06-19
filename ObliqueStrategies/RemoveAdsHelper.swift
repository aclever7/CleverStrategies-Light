//
//  RemoveAdsHelper.swift
//  ObliqueStrategies
//
//  Created by Anton C on 07/04/2019.
//  Copyright © 2019 Anton Zdasiuk. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

protocol CompletedFaildAlerts: class {
    func presentRestoreAlert()
    func presentCompleteAlert()
    func presentFailAlert()
}

extension Notification.Name {
    
    static let RemoveAdsHelperPurchaseNotification = Notification.Name("RemoveAdsHelperPurchaseNotification")
}

open class RemoveAdsHelper: NSObject  {
    
    weak var delegate: CompletedFaildAlerts?
    
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    public init(productIds: Set<ProductIdentifier>) {
        
        productIdentifiers = productIds
        
        for productIdentifier in productIds {
            
            let purchased = savedUserData.bool(forKey: productIdentifier)
            
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                savedUserData.set(true, forKey: "Purchased")
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// StoreKit API

extension RemoveAdsHelper {
    
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// SKProductsRequestDelegate

extension RemoveAdsHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// SKPaymentTransactionObserver

extension RemoveAdsHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue,
                             updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        
        savedUserData.set(true, forKey: "Purchased")
        delegate?.presentCompleteAlert()
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        
        savedUserData.set(true, forKey: "Purchased")
        delegate?.presentRestoreAlert()
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        delegate?.presentFailAlert()
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        savedUserData.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .RemoveAdsHelperPurchaseNotification, object: identifier)
    }
}
