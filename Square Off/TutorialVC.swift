//
//  TutorialVC.swift
//  Square Off
//
//  Created by Chris Brown on 4/13/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit
import Firebase

class TutorialVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    private var tutorialImages: [UIImage]!
    private var viewedEntireTutorial: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventTutorialBegin, parameters: nil)
        
        scrollView.delegate = self
        
        tutorialImages = [#imageLiteral(resourceName: "Tutorial00"),#imageLiteral(resourceName: "Tutorial01"),#imageLiteral(resourceName: "Tutorial02"),#imageLiteral(resourceName: "Tutorial03"),#imageLiteral(resourceName: "Tutorial04"),#imageLiteral(resourceName: "Tutorial05")]
        
        for index in 0..<tutorialImages.count {
            let tutorialImageView = UIImageView()
            tutorialImageView.image = tutorialImages[index]
            tutorialImageView.contentMode = .scaleAspectFit
            let xPos: CGFloat = view.frame.width * CGFloat(index)
            let frame: CGRect = CGRect(x: xPos, y: 0, width: view.frame.width, height: view.frame.height)
            tutorialImageView.frame = frame
            
            scrollView.contentSize.width = view.frame.width * CGFloat(index + 1)
            scrollView.addSubview(tutorialImageView)
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            checkHasScrolledToRight()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkHasScrolledToRight()
    }
    
    func checkHasScrolledToRight() {
        let rightEdge = scrollView.contentOffset.x + scrollView.frame.size.width
        if rightEdge >= scrollView.contentSize.width {
            viewedEntireTutorial = true
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        if viewedEntireTutorial {
            Analytics.logEvent(AnalyticsEventTutorialComplete, parameters: nil)
        }
        dismiss(animated: true, completion: nil)
    }
}
