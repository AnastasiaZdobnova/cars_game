//
//  MainScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 09.03.2024.
//

import Foundation
import UIKit

protocol MainScreenModelProtocol: AnyObject {
    var menuItems: [String] { get }
}

final class MainScreenModel: MainScreenModelProtocol {
    
    weak var mainScreenPresenter: MainScreenPresenterProtocol?
    
    let menuItems = [
        "Start",
        "Settings",
        "Records"
    ]
    
}
