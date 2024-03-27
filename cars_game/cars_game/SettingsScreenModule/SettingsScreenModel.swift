//
//  SettingsScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation

protocol SettingsScreenModelProtocol: AnyObject {
    func saveSettings(userName: String, carColorIndex: Int, obstacleTypeIndex: Int, difficultyIndex: Int, avatarImageData: Data?)
    func updateCurrentUser(name: String, userId: Int, image: Data?)
}

final class SettingsScreenModel: SettingsScreenModelProtocol {
    
    weak var settingsScreenPresenter: SettingsScreenPresenterProtocol?
     
    func saveSettings(userName: String, carColorIndex: Int, obstacleTypeIndex: Int, difficultyIndex: Int, avatarImageData: Data?) {
        let settings = Settings(
            userName: userName,
            carColorIndex: carColorIndex,
            obstacleTypeIndex: obstacleTypeIndex,
            difficultyIndex: difficultyIndex,
            avatarImageData: avatarImageData)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(settings)
            UserDefaults.standard.set(data, forKey: "settings")
        } catch {
            print("Error saving settings: \(error)")
        }
    }
    
    func updateCurrentUser(name: String, userId: Int, image: Data?) {
        var leaderboard = loadLeaderboard()
        if let index = leaderboard.firstIndex(where: { $0.id == userId }) {
            if name != leaderboard[index].name {
                leaderboard[index].name = name
                
            }
            leaderboard[index].avatarImageData = image
            saveLeaderboard(leaderboard)
        }
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
    
    private func loadLeaderboard() -> [Player] {
        if let data = UserDefaults.standard.data(forKey: "leaderboard"),
           let leaderboard = try? JSONDecoder().decode([Player].self, from: data) {
            return leaderboard
        }
        return []
    }
}
