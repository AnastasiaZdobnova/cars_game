//
//  RecordsScreenRouter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit

protocol RecordsScreenRouterProtocol {
    static func createModule() -> UIViewController
}

public class RecordsScreenRouter: RecordsScreenRouterProtocol {

    public static func createModule() -> UIViewController {
        let router = RecordsScreenRouter()
        let model = RecordsScreenModel()
        let presenter = RecordsScreenPresenter(model: model, router: router)
        let view = RecordsScreenViewController(presenter: presenter)

        model.recordsScreenPresenter = presenter
        presenter.recordsViewController = view

        return view
    }
}
