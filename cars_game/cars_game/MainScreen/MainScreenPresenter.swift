//
//  MainScreenPresenter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 09.03.2024.
//

import UIKit

protocol MainScreenPresenterProtocol: AnyObject {
    var mainScreenModel : MainScreenModelProtocol { get set }
    var mainScreenRouter: MainScreenRouter { get set }
    func getMenuItems() -> [String]
    func showScreen(number: Int)
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    var mainScreenModel: MainScreenModelProtocol
    var mainScreenRouter: MainScreenRouter
    
    weak var mainViewController: MainScreenViewController?
    
    init(model: MainScreenModelProtocol, router: MainScreenRouter) {
        self.mainScreenModel = model
        self.mainScreenRouter = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getMenuItems() -> [String] {
        return mainScreenModel.menuItems
    }
    
    func showScreen(number: Int) {
        switch number {
        case 0:
            mainScreenRouter.showGameScreen()
        case 1:
            mainScreenRouter.showSettingScreen()
        case 2:
            mainScreenRouter.showRecordsScreen()
        default:
            print("Error")
        }
    }
}
