//
//  GameScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation

protocol GameScreenModelProtocol: AnyObject {
    func updateCurrentUserScore(newScore: Int, userId: Int)
}

final class GameScreenModel: GameScreenModelProtocol {
    
    weak var gameScreenPresenter: GameScreenPresenterProtocol?
    
    func updateCurrentUserScore(newScore: Int, userId: Int) {
        var leaderboard = loadLeaderboard()
        if let index = leaderboard.firstIndex(where: { $0.id == userId }) {
            if newScore > leaderboard[index].score {
                leaderboard[index].score = newScore
                leaderboard[index].date = Date()
                saveLeaderboard(leaderboard)
            }
        }
    }

    private func loadLeaderboard() -> [Player] {
        if let data = UserDefaults.standard.data(forKey: "leaderboard"),
           let leaderboard = try? JSONDecoder().decode([Player].self, from: data) {
            return leaderboard
        }
        return []
    }

    private func saveLeaderboard(_ leaderboard: [Player]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(leaderboard)
            UserDefaults.standard.set(data, forKey: "leaderboard")
        } catch {
            print("Error saving leaderboard: \(error)")
        }
    }
}
