//
//  SettingsScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation

protocol SettingsScreenModelProtocol: AnyObject {
}

final class SettingsScreenModel: SettingsScreenModelProtocol {
    
    weak var settingsScreenPresenter: SettingsScreenPresenterProtocol?
     
}
