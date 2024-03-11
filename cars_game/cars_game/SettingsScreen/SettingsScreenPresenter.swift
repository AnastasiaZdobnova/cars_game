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
}
