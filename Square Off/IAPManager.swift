//
//  IAPManager.swift
//  Square Off
//
//  Created by Chris Brown on 4/12/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate {
    static let sharedInstance = IAPManager()
    
    var request: SKProductsRequest!
    var products: [SKProduct] = []
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        for product in products {
            print(product.localizedTitle)
        }
    }
    
    func performProductRequest(for productIdentifiers: Set<String>) {
        request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    func requestProducts() {
        let productIdentifiers: Set<String> = [Product.RemoveAds.rawValue]
        performProductRequest(for: productIdentifiers)
    }
}
