//
//  MenuViewController.swift
//  XO-game
//
//  Created by Денис Ледовский on 27.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

enum GameMode {
    case player, bot
}

class MenuViewController: UIViewController {

    let segueIdentifire = "fromMenuToGame"
    var gameMode: GameMode?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func chooseVsPlayer(_ sender: Any) {
        gameMode = .player
        performSegue(withIdentifier: segueIdentifire, sender: self)
    }

    
    @IBAction func chooseVsBot(_ sender: Any) {
        gameMode = .bot
        performSegue(withIdentifier: segueIdentifire, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifire,
           let sourceVC = segue.source as? MenuViewController,
           let destinationVC = segue.destination as? GameViewController{
            destinationVC.gameMode = sourceVC.gameMode
        }
    }
}
