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
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "brown_car")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var incomingCars: [UIImageView] = []
    private var incomingObstacles: [UIImageView] = []
    private var displayLink: CADisplayLink?
    private var carTimer: Timer?
    private var obstacleTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        navigationController?.isNavigationBarHidden = true
        setupGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        score = 0
        setupGame()
    }
    private var incomingObstacleType: String = "kust"
    private var animationDuration: TimeInterval = 5
    private func setupGame() {
        
        if let settings = loadSettings() {
            // Настройка машины
            let carColors = [UIImage(named: "red_car"), UIImage(named: "brown_car"), UIImage(named: "yellow_car")]
            carImageView.image = carColors[settings.carColorIndex]
            
            // Настройка препятствий
            let obstacleTypes = ["kust", "palm", "tree"]
            incomingObstacleType = obstacleTypes[settings.obstacleTypeIndex]
            
            // Настройка сложности (скорости анимации)
            animationDuration = settings.difficultyIndex == 0 ? 5 : settings.difficultyIndex == 1 ? 4 : 3
        }
        
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
        }
        drawRoad()
        setupCar()
        setupGestureRecognizers()
        startAddingCars()
        startObstacleTimer()
        setupDisplayLink()
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
        animation.duration = animationDuration
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
        
        switch gesture.direction {
        case .left:
            if carImageView.frame.minX > (view.frame.width - roadWidth) / 2 + laneWidth {
                UIView.animate(withDuration: 0.3) {
                    self.carImageView.frame.origin.x -= laneWidth
                }
            } else {
                handleCollision()
            }
        case .right:
            if carImageView.frame.maxX < (view.frame.width - roadWidth) / 2 + laneWidth {
                UIView.animate(withDuration: 0.3) {
                    self.carImageView.frame.origin.x += laneWidth
                }
            } else {
                handleCollision()
            }
        default:
            break
        }
    }
    
    private func addIncomingCar() {
        let incomingCarImageView = UIImageView(image: UIImage(named: "gray_car"))
        incomingCarImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        incomingCarImageView.contentMode = .scaleAspectFill
        incomingCarImageView.backgroundColor = .clear
        
        let roadWidth: CGFloat = 200
        let laneWidth: CGFloat = roadWidth / 2
        let carWidth: CGFloat = 50
        let carHeight: CGFloat = 100
        
        
        let randomLane = Int.random(in: 0...1)
        let xPos = (view.frame.width - roadWidth) / 2 + (randomLane == 0 ? laneWidth/2-carWidth/2 : laneWidth + laneWidth/2-carWidth/2)
        
        incomingCarImageView.frame = CGRect(
            x: xPos,
            y: -carHeight,
            width: carWidth,
            height: carHeight
        )
        
        view.addSubview(incomingCarImageView)
        incomingCars.append(incomingCarImageView)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveLinear], animations: {
            incomingCarImageView.frame.origin.y = self.view.frame.height
        }) { [weak self] _ in
            self?.incomingCars.removeAll { $0 === incomingCarImageView }
            incomingCarImageView.removeFromSuperview()
            self?.increaseScore()
        }
    }
    
    private func addIncomingObstacles() {
        let incomingObstaclesImageView = UIImageView(image: UIImage(named: incomingObstacleType))
        incomingObstaclesImageView.contentMode = .scaleAspectFill
        incomingObstaclesImageView.backgroundColor = .clear
        
        let roadWidth: CGFloat = 200
        let laneWidth: CGFloat = (view.frame.width - roadWidth) / 2 // ширина обочины
        let obstaclesWidth: CGFloat = 50
        let obstaclesHeight: CGFloat = 50
        
        
        let randomLane = Int.random(in: 0...1) // левая или правая обочина
        let xPos = randomLane == 0 ? laneWidth/2 - obstaclesWidth/2 : view.frame.width - laneWidth/2 - obstaclesWidth/2
        
        incomingObstaclesImageView.frame = CGRect(
            x: xPos,
            y: -100, // TODO: вынести отдельно
            width: obstaclesWidth,
            height: obstaclesHeight
        )
        
        view.addSubview(incomingObstaclesImageView)
        incomingObstacles.append(incomingObstaclesImageView)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveLinear], animations: {
            incomingObstaclesImageView.frame.origin.y = self.view.frame.height
        }) { [weak self] _ in
            self?.incomingObstacles.removeAll { $0 === incomingObstaclesImageView }
            incomingObstaclesImageView.removeFromSuperview()
        }
    }
    
    private func startAddingCars() {
        carTimer?.invalidate() // Останавливаем предыдущий таймер, если он существует
        carTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            self?.addIncomingCar()
            self?.addIncomingObstacles()
        }
    }
    
    private func startObstacleTimer() {
        obstacleTimer?.invalidate()
        obstacleTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 1...3), repeats: true) { [weak self] timer in
            self?.addIncomingObstacles()
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
        displayLink?.invalidate()
        displayLink = nil
        incomingCars.forEach { car in
            car.layer.removeAllAnimations() // Останавливаем анимацию
            car.removeFromSuperview()
        }
        incomingCars.removeAll()
        incomingObstacles.forEach { obstacles in
            obstacles.layer.removeAllAnimations() // Останавливаем анимацию
            obstacles.removeFromSuperview()
        }
        incomingCars.removeAll()
        incomingObstacles.removeAll()
        carTimer?.invalidate()
        obstacleTimer?.invalidate()
        gamePresenter.gameOver(score: self.score)
    }
    
    private func increaseScore() {
        score += 1
    }
    
    func loadSettings() -> Settings? {
        if let data = UserDefaults.standard.data(forKey: "settings") {
            return try? JSONDecoder().decode(Settings.self, from: data)
        }
        return nil
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
