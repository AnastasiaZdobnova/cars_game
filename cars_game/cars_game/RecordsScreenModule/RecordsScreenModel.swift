//
//  RecordsScreenModel.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation

protocol RecordsScreenModelProtocol: AnyObject {
}

final class RecordsScreenModel: RecordsScreenModelProtocol {
    
    weak var recordsScreenPresenter: RecordsScreenPresenterProtocol?
    
}
