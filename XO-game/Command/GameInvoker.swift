//
//  GameInvoker.swift
//  XO-game
//
//  Created by Денис Ледовский on 29.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

final class GameCommandInvoker {

    let pause = 250
    let fiveStep = 5
    let receiver = GameCommandReceiver()
    var commands: [GameCommand] = []



    func addGameCommand(command: GameCommand) {
        let playerCommands = commands.filter { $0.player == command.player }
        let playerPositions = playerCommands.map { $0.position }
        if playerCommands.count < fiveStep,
           !playerPositions.contains(command.position) { commands.append(command) }
    }

    public func isFiveStep(player: Player) -> Bool {
        commands.filter { $0.player == player }.count >= fiveStep
    }

    public func clear() {
        commands.removeAll()
    }

    public func executeCommands(completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        commands.enumerated().forEach {
            self.receiver.execute(command: $0.element,
                                  deadline: $0.offset * pause,
                                  dispatchGroup: group)
        }
        group.notify(queue: .main) {
            completion(true)
        }
    }
}
