//
//  PlayOptionVC.swift
//  Square Off
//
//  Created by Chris Brown on 2/27/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

protocol PlayOptionVCDataSource {
    func currentPlayer() -> Player
    func playOptionChoices() -> [PlayOption]
}

protocol PlayOptionVCDelegate {
    func chosenAction(action: PathAction)
}

class PlayOptionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource: PlayOptionVCDataSource!
    var delegate: PlayOptionVCDelegate!
    
    private let playOptions: [PlayOption]
    private var playOptionTableView: UITableView
    
    init(playOptions: [PlayOption]) {
        playOptionTableView = UITableView()
        
        self.playOptions = playOptions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.offWhite
        showAnimate()
    }
    
    private func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        view.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func dismissAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.view.alpha = 0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
    
    // MARK: - TableView DataSource and Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = playOptionTableView.dequeueReusableCell(withIdentifier: "playOptionCell", for: indexPath) as? PlayOptionCell {
            let playOption = playOptions[indexPath.row]
            cell.configure(playOption)
            return cell
        } else {
            return PlayOptionCell()
        }
    }
}
