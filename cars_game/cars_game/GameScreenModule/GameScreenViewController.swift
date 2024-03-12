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
    
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.image = UIImage(named: "car")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func setupGame() {
        drawRoad()
        setupCar()
        setupGestureRecognizers()
        startAddingCars()
        setupDisplayLink()
    }
    
    private var incomingCars: [UIImageView] = []
    private var displayLink: CADisplayLink?
    private var carTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        navigationController?.isNavigationBarHidden = true
        setupGame()
        print("Я на экране с игрой")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear+ cars \(incomingCars)")
        incomingCars.forEach { car in
            car.layer.removeAllAnimations() // Останавливаем анимацию
            car.removeFromSuperview()
        }
        incomingCars.removeAll()
        setupGame()
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
        animation.duration = 5
        animation.repeatCount = .infinity
        dashedLineLayer.add(animation, forKey: "lineAnimation")
    }
    
    private func setupCar() {
        view.addSubview(carImageView)
        let roadWidth: CGFloat = 200
        let laneWidth: CGFloat = roadWidth / 2
        let carWidth: CGFloat = 50
        let carHeight: CGFloat = 100
        carImageView.frame = CGRect(
            x: (view.frame.width + laneWidth - carWidth) / 2,
            y: view.frame.height - carHeight - 20,
            width: carWidth,
            height: carHeight
        )
        
    }
    
    private func setupGestureRecognizers() {
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGestureRecognizer.direction = .left
        view.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let roadWidth: CGFloat = 200
        let laneWidth: CGFloat = roadWidth / 2
        let carWidth: CGFloat = 50
        
        switch gesture.direction {
        case .left:
            if carImageView.frame.minX > (view.frame.width - roadWidth) / 2 {
                UIView.animate(withDuration: 0.3) {
                    self.carImageView.frame.origin.x -= laneWidth
                }
            }
        case .right:
            if carImageView.frame.maxX < (view.frame.width + roadWidth) / 2 {
                UIView.animate(withDuration: 0.3) {
                    self.carImageView.frame.origin.x += laneWidth
                }
            }
        default:
            break
        }
    }
    
    private func addIncomingCar() {
        let incomingCarImageView = UIImageView(image: UIImage(named: "megaCar"))
        incomingCarImageView.contentMode = .scaleAspectFit
        incomingCarImageView.backgroundColor = .yellow
        
        let roadWidth: CGFloat = 200
        let laneWidth: CGFloat = roadWidth / 2
        let carWidth: CGFloat = 50
        let carHeight: CGFloat = 100
        
        
        let randomLane = Int.random(in: 0...1)
        let xPos = (view.frame.width - roadWidth) / 2 + (randomLane == 0 ? 0 : laneWidth)
        
        incomingCarImageView.frame = CGRect(
            x: xPos,
            y: -carHeight, // Start above the screen
            width: carWidth,
            height: carHeight
        )
        
        view.addSubview(incomingCarImageView)
        incomingCars.append(incomingCarImageView)
        
        UIView.animate(withDuration: 5, delay: 0, options: [.curveLinear], animations: {
            incomingCarImageView.frame.origin.y = self.view.frame.height
        }) { [weak self] _ in
            self?.incomingCars.removeAll { $0 === incomingCarImageView }
            incomingCarImageView.removeFromSuperview()
        }
    }
    
    private func startAddingCars() {
        carTimer?.invalidate() // Останавливаем предыдущий таймер, если он существует
        carTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            self?.addIncomingCar()
        }
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    @objc private func step(displaylink: CADisplayLink) {
        for incomingCar in incomingCars {
            if let presentationFrame = incomingCar.layer.presentation()?.frame {
                if carImageView.frame.intersects(presentationFrame) {
                    handleCollision()
                    return
                }
            }
        }
    }
    
    private func handleCollision() {
        print("Столкновение произошло!")
        displayLink?.invalidate()
        displayLink = nil
        incomingCars.forEach { car in
            car.layer.removeAllAnimations() // Останавливаем анимацию
            car.removeFromSuperview()
        }
        incomingCars.removeAll()
        carTimer?.invalidate()
        gamePresenter.gameOver()
        // Останавливаем игру или показываем алерт
    }
    
    init(presenter: GameScreenPresenterProtocol) {
        self.gamePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        displayLink?.invalidate()
    }
}
