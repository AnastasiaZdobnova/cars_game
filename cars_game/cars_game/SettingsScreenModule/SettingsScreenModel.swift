//
//  SettingsScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol SettingsScreenModelProtocol: AnyObject {
    func saveSettings(userName: String, carColorIndex: Int, obstacleTypeIndex: Int, difficultyIndex: Int, avatarImageData: UIImage)
    func updateCurrentUser(name: String, userId: Int, image: UIImage)
}

final class SettingsScreenModel: SettingsScreenModelProtocol {
    
    weak var settingsScreenPresenter: SettingsScreenPresenterProtocol?
    
    func saveSettings(userName: String, carColorIndex: Int, obstacleTypeIndex: Int, difficultyIndex: Int, avatarImageData: UIImage) {
        let image = try? saveImage(avatarImageData)
        let settings = Settings(
            userName: userName,
            carColorIndex: carColorIndex,
            obstacleTypeIndex: obstacleTypeIndex,
            difficultyIndex: difficultyIndex,
            avatarImageData: try? saveImage(avatarImageData))
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(settings)
            UserDefaults.standard.set(data, forKey: "settings")
        } catch {
            print("Error saving settings: \(error)")
        }
    }
    
    func updateCurrentUser(name: String, userId: Int, image: UIImage) {
        var leaderboard = loadLeaderboard()
        if let index = leaderboard.firstIndex(where: { $0.id == userId }) {
            if name != leaderboard[index].name {
                leaderboard[index].name = name
                
            }
            leaderboard[index].avatarImageData = try? saveImage(image)
            saveLeaderboard(leaderboard)
        }
    }
    
    private func saveImage(_ image: UIImage) throws -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let name = "image"
        let url = directory.appendingPathComponent(name)
        
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(atPath: url.path)
        }
        
        try data.write(to: url)
        return name
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
