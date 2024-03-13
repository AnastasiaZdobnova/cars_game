//
//  SettingsScreenRouter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol SettingsScreenRouterProtocol {
    static func createModule() -> UIViewController
}

public class SettingsScreenRouter: SettingsScreenRouterProtocol {

    public static func createModule() -> UIViewController {
        let router = SettingsScreenRouter()
        let model = SettingsScreenModel()
        let presenter = SettingsScreenPresenter(model: model, router: router)
        let view = SettingsScreenViewController(presenter: presenter)

        model.settingsScreenPresenter = presenter
        presenter.settingsViewController = view

        return view
    }
}
