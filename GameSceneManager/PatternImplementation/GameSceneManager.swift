//
//  GameSceneManager.swift
//  GameSceneManager
//
//  Created by Praveen Jangre on 11/07/2025.
//

import Foundation

public final class GameScene {
    public var score: UInt = 0
    
    public var progress: Float = 0 {
        didSet {
            // keep progress in 0% - 100% range
            progress = min(max(progress, 0), 100)
        }
    }
    
    private var sessionTime: TimeInterval = 0
    
    lazy private var sessionTimer = Timer.init(timeInterval: 1, repeats: true) { timer in
        self.sessionTime += timer.timeInterval
    }
    
    public func start() {
        RunLoop.current.add(sessionTimer, forMode: RunLoop.Mode.default)
        sessionTimer.fire()
    }
}

extension GameScene: CustomStringConvertible {
    public var description: String {
        return "Level progress \(progress), player score \(score). Play time \(sessionTime) seconds"
    }
}

// Memento
protocol Memento {
    associatedtype State
    var state: State { get set }
    
}

protocol Originator {
    associatedtype M: Memento
    
    func createMemento() -> M
    mutating func apply(memento: M)
}


protocol Caretaker {
    associatedtype O: Originator
    
    func saveState(originator: O, identifier: AnyHashable)
    func restoreState(originator: inout O, identifier: AnyHashable)
}

struct GameMemento: Memento {
    var state: ExternalGameState
    
    
}

struct ExternalGameState {
    var playerScore: UInt
    var levelProgress: Float
}

extension GameScene: Originator {
    func createMemento() -> GameMemento {
        let currentState = ExternalGameState(playerScore: score, levelProgress: progress)
        return GameMemento(state: currentState)
    }
    
    func apply(memento: GameMemento) {
        let restoreState = memento.state
        score = restoreState.playerScore
        progress = restoreState.levelProgress
    }
}


final class GameSceneManager: Caretaker {

    private var snapshots = [AnyHashable: GameMemento]()
    
    func saveState(originator: GameScene, identifier: AnyHashable) {
        let snapshot = originator.createMemento()
        snapshots[identifier] = snapshot
    }
    
    func restoreState(originator: inout GameScene, identifier: AnyHashable) {
        if let snapshot = snapshots[identifier] {
            originator.apply(memento: snapshot)
        }
    }
    
    
}




func startGameScene() {
    var gameScene = GameScene()
    gameScene.start()
    
    
    let sceneManager = GameSceneManager()
    sceneManager.saveState(originator: gameScene, identifier: "initial")
    print(gameScene)
    
    // First update after 3 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)){
        gameScene.progress = 55
        gameScene.score = 2500
        sceneManager.saveState(originator: gameScene, identifier: "snapshot_1")
        print(gameScene)
        
    }
    
    // Second update after 2 more seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)){
        gameScene.progress = 80
        gameScene.score = 9000
        sceneManager.saveState(originator: gameScene, identifier: "snapshot_2")
        print(gameScene)
        
    }
    
    // Restoring the state  after 5 more seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)){
        
        print("\n Restoring \"initial\" ")
        sceneManager.restoreState(originator: &gameScene, identifier: "initial")
        print(gameScene)
        
    }
    
    // Restoring the another state  after 5 more seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(15)){
        
        print("\n Restoring \"snapshot_2\" ")
        sceneManager.restoreState(originator: &gameScene, identifier: "snapshot_2")
        print(gameScene)
        
    }
}
