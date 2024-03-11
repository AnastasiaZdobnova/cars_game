//
//  mainScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 09.03.2024.
//

import Foundation
import UIKit

protocol MainModel: AnyObject {
    var menuItems: [String] { get }
}

final class mainScreenModel: MainModel {
    
    weak var mainScreenPresenter: MainPresenter?
    
    let menuItems = [
        "Start",
        "Settings",
        "Records"
    ]
    
}
