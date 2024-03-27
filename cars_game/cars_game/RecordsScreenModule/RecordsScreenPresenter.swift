//
//  RecordsScreenPresenter.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import Foundation
import UIKit

protocol RecordsScreenPresenterProtocol: AnyObject {
    var recordsScreenModel : RecordsScreenModelProtocol { get set }
    var recordsScreenRouter: RecordsScreenRouter { get set }
    func loadLeaderboard() -> [Player]
}

final class RecordsScreenPresenter: RecordsScreenPresenterProtocol {
   
    var recordsScreenModel: RecordsScreenModelProtocol
    var recordsScreenRouter: RecordsScreenRouter
    
    weak var recordsViewController: RecordsScreenViewController?

    init(model: RecordsScreenModelProtocol, router: RecordsScreenRouter) {
        self.recordsScreenModel = model
        self.recordsScreenRouter = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLeaderboard() -> [Player] {
        if let data = UserDefaults.standard.data(forKey: "leaderboard"),
           var leaderboard = try? JSONDecoder().decode([Player].self, from: data) {
            leaderboard.sort(by: { $0.score > $1.score })
            return leaderboard
        }
        return []
    }
}
