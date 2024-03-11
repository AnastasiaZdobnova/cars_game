//
//  mainScreenRouter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol MainScreenRouter {
    static func createModule() -> UIViewController 
}

public class mainScreenRouter: MainScreenRouter {

    public static func createModule() -> UIViewController {
        let router = mainScreenRouter()
        let model = mainScreenModel()
        let presenter = mainScreenPresenter(model: model, router: router)
        let view = mainScreenViewController(presenter: presenter)

        model.mainScreenPresenter = presenter
        presenter.mainViewController = view

        return view
    }
}
