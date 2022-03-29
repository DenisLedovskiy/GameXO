//
//  PlayerInputStateCommand.swift
//  XO-game
//
//  Created by Денис Ледовский on 29.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

public class PlayerInputStateCommand: InputState {

    public var isCompleted = false
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    private(set) weak var gameCommandInvoker: GameCommandInvoker?

    init(player: Player,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView,
         gameCommandInvoker: GameCommandInvoker) {

        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.gameCommandInvoker = gameCommandInvoker
    }

    public func begin() {
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        }

        self.gameViewController?.winnerLabel.isHidden = true
    }

    public func addMark(at position: GameboardPosition?) {
        guard let position = position,
              let gameboard = gameboard,
              let gameboardView = gameboardView,
              let gameViewController = gameViewController else { return }
        self.gameCommandInvoker?.addGameCommand(command: GameCommand(player: self.player,
                                                 position: position,
                                                 gameViewController: gameViewController,
                                                 gameboard: gameboard,
                                                 gameboardView: gameboardView))
        
        self.isCompleted = self.gameCommandInvoker?.isFiveStep(player: self.player) ?? false
    }
}

