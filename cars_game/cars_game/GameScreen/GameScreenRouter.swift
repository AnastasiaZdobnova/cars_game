//
//  GameScreenRouter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol GameScreenRouterProtocol {
    static func createModule() -> UIViewController
}

public class GameScreenRouter: GameScreenRouterProtocol {

    public static func createModule() -> UIViewController {
        let router = GameScreenRouter()
        let model = GameScreenModel()
        let presenter = GameScreenPresenter(model: model, router: router)
        let view = GameScreenViewController(presenter: presenter)

        model.gameScreenPresenter = presenter
        presenter.gameViewController = view

        return view
    }
}
