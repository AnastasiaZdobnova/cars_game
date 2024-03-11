//
//  GameScreenViewController.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol GameScreenViewControllerProtocol : UIViewController {
    var gamePresenter: GameScreenPresenterProtocol { get }
}

class GameScreenViewController: UIViewController, GameScreenViewControllerProtocol {
    
    var gamePresenter: GameScreenPresenterProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink // TODO: вынести отдельно
        navigationController?.isNavigationBarHidden = false
        drawRoad()
    }
    
    func drawRoad() {
            let roadWidth: CGFloat = 200
            let laneWidth: CGFloat = roadWidth / 2
            let dashedLineLength: CGFloat = 10
            let dashedLineSpacing: CGFloat = 10

            let roadLayer = CAShapeLayer()
            roadLayer.frame = CGRect(x: (view.frame.width - roadWidth) / 2, y: 0, width: roadWidth, height: view.frame.height)
            roadLayer.backgroundColor = UIColor.darkGray.cgColor
            view.layer.addSublayer(roadLayer)

            let dashedLineLayer = CAShapeLayer()
            dashedLineLayer.strokeColor = UIColor.white.cgColor
            dashedLineLayer.lineWidth = 2
            dashedLineLayer.lineDashPattern = [NSNumber(value: Float(dashedLineLength)), NSNumber(value: Float(dashedLineSpacing))]
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: laneWidth, y: -view.frame.height), CGPoint(x: laneWidth, y: 2 * view.frame.height)])
            dashedLineLayer.path = path
            roadLayer.addSublayer(dashedLineLayer)

            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = -view.frame.height
            animation.toValue = 0
            animation.duration = 10
            animation.repeatCount = .infinity
            dashedLineLayer.add(animation, forKey: "lineAnimation")
        }
    
    init(presenter: GameScreenPresenterProtocol) {
        self.gamePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
