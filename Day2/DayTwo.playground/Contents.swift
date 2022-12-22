import UIKit
import XCPlayground
import PlaygroundSupport

protocol Pointable {
    var points: Int { get }
}

enum HandShape {
    
    case rock
    case paper
    case scissors
    
    init(move: String) {
        switch move {
        case "A", "X":
            self = .rock
        case "B", "Y":
            self = .paper
        case "C", "Z":
            self = .scissors
        default:
            fatalError("Unhandled shape")
        }
    }
    
}
extension HandShape: Pointable {
    var points: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scissors:
            return 3
        }
    }
}

enum Outcome {
    
    case win
    case loss
    case tie
    
    init(secretMove: String) {
        switch secretMove {
        case "X":
            self = .loss
        case "Y":
            self = .tie
        case "Z":
            self = .win
        default:
            fatalError()
        }
    }
    
}

extension Outcome: Pointable {
    var points: Int {
        switch self {
        case .win:
            return 6
        case .loss:
            return 0
        case .tie:
            return 3
        }
    }
}

struct MoveResult {
    
    let handShape: HandShape
    let outcome: Outcome
    
}

struct PointManager {
    
    let gameResult: GameResult
    
    func pointsForOpponent() -> Int {
        gameResult.opponentMoveResult.outcome.points +
        gameResult.opponentMoveResult.handShape.points
    }
    
    func pointsForYou() -> Int {
        gameResult.yourMoveResult.outcome.points +
        gameResult.yourMoveResult.handShape.points
    }
    
}

struct GameResult {
    
    let yourMoveResult: MoveResult
    let opponentMoveResult: MoveResult
    
}

struct RulesManager {
    
    let opponentMove: HandShape
    let yourMove: HandShape
    
    func play() -> GameResult {
        let outcomes: (yourOutcome: Outcome, opponentOutcome: Outcome) = {
            if opponentMove == .rock && yourMove == .scissors {
                return (yourOutcome: Outcome.loss, opponentOutcome: Outcome.win)
            } else if yourMove == .rock && opponentMove == .scissors {
                return (yourOutcome: Outcome.win, opponentOutcome: Outcome.loss)
            } else if opponentMove == .scissors && yourMove == .paper {
                return (yourOutcome: Outcome.loss, opponentOutcome: Outcome.win)
            } else if yourMove == .scissors && opponentMove == .paper {
                return (yourOutcome: Outcome.win, opponentOutcome: Outcome.loss)
            } else if opponentMove == .paper && yourMove == .rock {
                return (yourOutcome: Outcome.loss, opponentOutcome: Outcome.win)
            } else if yourMove == .paper && opponentMove == .rock {
                return (yourOutcome: Outcome.win, opponentOutcome: Outcome.loss)
            } else {
                return (yourOutcome: Outcome.tie, opponentOutcome: Outcome.tie)
            }
        }()
        return GameResult(yourMoveResult: MoveResult(handShape: yourMove, outcome: outcomes.yourOutcome), opponentMoveResult: MoveResult(handShape: opponentMove, outcome: outcomes.opponentOutcome))
    }
    
}

struct GuessManager {
    
    var opponentMove: HandShape
    var neededOutcome: Outcome
    
    func guessMove() -> HandShape {
        switch neededOutcome {
        case .tie:
            return opponentMove
        case .win:
            if opponentMove == .scissors { return .rock }
            else if opponentMove == .rock { return .paper }
            else if opponentMove == .paper { return .scissors }
        case .loss:
            if opponentMove == .scissors { return .paper }
            else if opponentMove == .rock { return .scissors }
            else if opponentMove == .paper { return .rock }
        }
        fatalError()
    }
    
}

do {
    guard let path = Bundle.main.url(forResource: "input", withExtension: "txt") else { fatalError() }
    let games = try String(contentsOf: path, encoding: .utf8)
        .components(separatedBy: "\n")
        .map { $0.components(separatedBy: " ") }
    
    var yourPoints = 0
    var opponentPoints = 0
    
    for game in games {
        guard let opponentLetter = game.first, let yourLetter = game.last else { fatalError() }
        let opponentMove = HandShape(move: opponentLetter)
        let yourMove = GuessManager(opponentMove: opponentMove, neededOutcome: Outcome(secretMove: yourLetter))
            .guessMove()
        
        let gameResult = RulesManager(opponentMove: opponentMove, yourMove: yourMove).play()
        let pointsManager = PointManager(gameResult: gameResult)
        yourPoints += pointsManager.pointsForYou()
        opponentPoints += pointsManager.pointsForOpponent()
    }
    
    print(yourPoints)
    
} catch(let error) {
    print(error)
}

