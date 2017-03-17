//
//  Extensions.swift
//  Square Off
//
//  Created by Chris Brown on 2/15/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

extension GameVC: UIViewControllerPreviewingDelegate {
    
    // Peek
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let previewVC = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") else { return nil }
        
        previewVC.preferredContentSize = CGSize(width: 100, height: 100)
        
//        previewingContext.sourceRect = discardSlot.frame
        
        return previewVC
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
}

extension CGRect {
    var center: CGPoint {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return CGPoint(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}

extension CGPoint {
    func distanceTo(_ point: CGPoint) -> CGFloat {
        let xDist = self.x - point.x
        let yDist = self.y - point.y
        return CGFloat(sqrt(pow(xDist,2) + pow(yDist,2)))
    }
}

extension Hand: Sequence {
    func makeIterator() -> AnyIterator<Card> {
        return AnyIterator(cards.makeIterator())
    }
}
