//
//  PlayerState.swift
//  XO-game
//
//  Created by Денис Ледовский on 29.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

public class PlayerState: InputState {

    public var isCompleted = false
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?

    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {

        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
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
              let gameboardView = self.gameboardView,
              gameboardView.canPlaceMarkView(at: position) else { return }

        let markView = XView()
        self.gameboard?.setPlayer(self.player, at: position)
        self.gameboardView?.placeMarkView(markView, at: position)
        self.isCompleted = true
    }
}
