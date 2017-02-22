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
        
        previewingContext.sourceRect = discardSlot.frame
        
        return previewVC
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
}
