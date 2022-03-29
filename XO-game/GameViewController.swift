//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!

    var gameMode: GameMode?
    var playersStates: [Player: InputState] = [:]
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet { self.currentState.begin()
        }
    }
    private lazy var referee = Referee(gameboard: self.gameboard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        startNewGame()
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        startNewGame()
    }

    private func goToFirstStatePlayer() {

        playersStates[Player.first] = PlayerInputState(player: .first,
                                                       gameViewController: self,
                                                       gameboard: gameboard,
                                                       gameboardView: gameboardView)

        playersStates[Player.second] = PlayerInputState(player: .second,
                                                        gameViewController: self,
                                                        gameboard: gameboard,
                                                        gameboardView: gameboardView)
    }

    private func goToFirstStateBot() {

        playersStates[Player.first] = PlayerState(player: .first,
                                                  gameViewController: self,
                                                  gameboard: gameboard,
                                                  gameboardView: gameboardView)

        playersStates[Player.second] = ComputerInputState(player: .second,
                                                          gameViewController: self,
                                                          gameboard: gameboard,
                                                          gameboardView: gameboardView)
    }

    func goToFirstState() {

        switch self.gameMode {
        case .player:
            goToFirstStatePlayer()
        case .bot:
            goToFirstStateBot()
        case .none:
            print("Не выбран режим")
        }
    }

    func startNewGame() {
        gameboardView.clear()
        gameboard.clear()
        currentState = playersStates[.first]
        currentState.isCompleted = false
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }

    }

    private func goToNextState() {

           if let winner = referee.determineWinner() {
               currentState = GameEndedState(winner: winner, gameViewController: self)
               return
           }


        if let playerInputState = currentState as? InputState {
            currentState = playersStates[playerInputState.player.next]
            currentState.isCompleted = false
            if currentState is ComputerInputState {
                gameboardView.onSelectPosition = nil
                currentState.addMark(at: nil)
                if currentState.isCompleted {
                    goToNextState()
                }
            } else {
                gameboardView.onSelectPosition = { [weak self] position in
                    guard let self = self else { return }
                    self.currentState.addMark(at: position)
                    if self.currentState.isCompleted {
                        self.goToNextState()
                    }
                }
            }
        }
    }
}

