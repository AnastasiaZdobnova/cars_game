//
//  mainScreenPresenter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 09.03.2024.
//

import UIKit

protocol MainPresenter: AnyObject {
    var mainScreenModel : MainModel { get set }
    var mainScreenRouter: MainScreenRouter { get set }
}

final class mainScreenPresenter: MainPresenter {
   
    var mainScreenModel: MainModel
    var mainScreenRouter: MainScreenRouter
    
    weak var mainViewController: MainScreenViewController?

    init(model: MainModel, router: MainScreenRouter) {
        self.mainScreenModel = model
        self.mainScreenRouter = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
