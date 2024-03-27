//
//  RecordsScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation

protocol RecordsScreenModelProtocol: AnyObject {
    func loadLeaderboard() -> [Player]
}

final class RecordsScreenModel: RecordsScreenModelProtocol {
    
    weak var recordsScreenPresenter: RecordsScreenPresenterProtocol?
    
    func loadLeaderboard() -> [Player] {
        if let data = UserDefaults.standard.data(forKey: "leaderboard"),
           var leaderboard = try? JSONDecoder().decode([Player].self, from: data) {
            leaderboard.sort(by: { $0.score > $1.score })
            return leaderboard
        }
        return []
    }
}
