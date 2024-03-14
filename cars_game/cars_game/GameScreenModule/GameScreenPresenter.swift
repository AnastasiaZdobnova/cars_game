//
//  GameScreenPresenter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol GameScreenPresenterProtocol: AnyObject {
    var gameScreenModel : GameScreenModelProtocol { get set }
    var gameScreenRouter: GameScreenRouter { get set }
    func gameOver(score: Int)
}

final class GameScreenPresenter: GameScreenPresenterProtocol {
   
    var gameScreenModel: GameScreenModelProtocol
    var gameScreenRouter: GameScreenRouter
    
    weak var gameViewController: GameScreenViewController?

    init(model: GameScreenModelProtocol, router: GameScreenRouter) {
        self.gameScreenModel = model
        self.gameScreenRouter = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameOver(score: Int){
        
        gameScreenRouter.gameOver(score: score)
        updateCurrentUserScore(newScore: score, userId: 79)
    }
    func updateCurrentUserScore(newScore: Int, userId: Int) {
        var leaderboard = loadLeaderboard()
        if let index = leaderboard.firstIndex(where: { $0.id == userId }) {
            if newScore > leaderboard[index].score {
                leaderboard[index].score = newScore
                saveLeaderboard(leaderboard)
            }
        }
    }

    func loadLeaderboard() -> [Player] {
        if let data = UserDefaults.standard.data(forKey: "leaderboard"),
           let leaderboard = try? JSONDecoder().decode([Player].self, from: data) {
            return leaderboard
        }
        return []
    }

    func saveLeaderboard(_ leaderboard: [Player]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(leaderboard)
            UserDefaults.standard.set(data, forKey: "leaderboard")
        } catch {
            print("Error saving leaderboard: \(error)")
        }
    }

}
