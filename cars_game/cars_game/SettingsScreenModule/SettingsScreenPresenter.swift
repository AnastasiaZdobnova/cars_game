//
//  SettingsScreenPresenter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol SettingsScreenPresenterProtocol: AnyObject {
    var settingsScreenModel : SettingsScreenModelProtocol { get set }
    var settingsScreenRouter: SettingsScreenRouter { get set }
    func saveSettings(userName: String, carColorIndex: Int, obstacleTypeIndex: Int, difficultyIndex: Int, avatarImageData: Data?)
    func updateCurrentUser(name: String, userId: Int, image: Data?)
}

final class SettingsScreenPresenter: SettingsScreenPresenterProtocol {
   
    var settingsScreenModel: SettingsScreenModelProtocol
    var settingsScreenRouter: SettingsScreenRouter
    
    weak var settingsViewController: SettingsScreenViewController?

    init(model: SettingsScreenModelProtocol, router: SettingsScreenRouter) {
        self.settingsScreenModel = model
        self.settingsScreenRouter = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func saveSettings(userName: String, carColorIndex: Int, obstacleTypeIndex: Int, difficultyIndex: Int, avatarImageData: Data?) {
        settingsScreenModel.saveSettings(userName: userName, carColorIndex: carColorIndex, obstacleTypeIndex: obstacleTypeIndex, difficultyIndex: difficultyIndex, avatarImageData: avatarImageData)
    }
    
    func updateCurrentUser(name: String, userId: Int, image: Data?) {
        settingsScreenModel.updateCurrentUser(name: name, userId: userId, image: image)
    }
}
