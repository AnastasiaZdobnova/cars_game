//
//  SettingsScreenViewController.swift
//  cars_game
//
//  Created by Анастасия Здобнова on 11.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol SettingsScreenViewControllerProtocol : UIViewController {
    var settingsPresenter: SettingsScreenPresenterProtocol { get }
}

class SettingsScreenViewController: UIViewController, SettingsScreenViewControllerProtocol {
    
    var settingsPresenter: SettingsScreenPresenterProtocol
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.backgroundAppColor
        navigationController?.isNavigationBarHidden = false
        setupScrollView()
        setupContentView()
        setupAvatarImageView()
        setupNameLabel()
        setupNameTextField()
        setupCarsColorLabel()
        setupColorSelectionCollectionView()
        setupTypeOfObstaclesLabel()
        setupObstaclesSelectionCollectionView()
        setupDifficultyLabel()
        setupDifficultySelectionCollectionView()
        setupSaveSettingsButton()
        loadSettings()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.backgroundAppColor // Задайте желаемый цвет фона
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    private func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "settings"),
           let settings = try? JSONDecoder().decode(Settings.self, from: data) {
            // Загружаем настройки
            nameTextField.text = settings.userName
            selectedColorIndex = settings.carColorIndex
            selectedObstaclesIndex = settings.obstacleTypeIndex
            selectedDifficultyIndex = settings.difficultyIndex
            colorSelectionCollectionView.reloadData()
            obstaclesSelectionCollectionView.reloadData()
            difficultyCollectionView.reloadData()

            // Загружаем изображение аватара
            if let avatarImageData = UserDefaults.standard.data(forKey: "avatarImageData") {
                avatarImageView.image = UIImage(data: avatarImageData)
            }
        }
    }
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColors.defaultAvatarImageAppColor
        imageView.layer.cornerRadius = 50 // Half of the width and height
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let imagePicker = UIImagePickerController() // ??
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "SuperUser"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = .white
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let carsColorLabel: UILabel = {
        let label = UILabel()
        label.text = "Cars color"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var colorSelectionCollectionView: UICollectionView!
    private var selectedColorIndex = 1
    private let colorsArray = [AppColors.redCar, AppColors.brownCar, AppColors.yellowCar]
    
    private let typeOfObstaclesLabel: UILabel = {
        let label = UILabel()
        label.text = "Type of obstacles"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var obstaclesSelectionCollectionView: UICollectionView!
    private var selectedObstaclesIndex = 1
    private let obstaclesArray = ["kust", "palm", "tree"]
    
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.text = "Difficulty"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var difficultyCollectionView: UICollectionView!
    private var selectedDifficultyIndex = 2
    private let difficultyArray = ["easy", "medium", "hard"]
    
    private let saveSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Settings", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = AppColors.buttonAppColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    func setupAvatarImageView(){
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.width.height.equalTo(100)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    @objc private func presentImagePicker() {
        present(imagePicker, animated: true)
    }
    
    private func setupNameLabel(){
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(36)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(26)
        }
    }
    
    private func setupNameTextField() {
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.equalTo(175)
            make.height.equalTo(40)
        }
        nameTextField.delegate = self
    }
    
    private func setupCarsColorLabel(){
        contentView.addSubview(carsColorLabel)
        carsColorLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(35)
            make.leading.equalTo(avatarImageView)
        }
    }
    
    func setupColorSelectionCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        colorSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colorSelectionCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        colorSelectionCollectionView.dataSource = self
        colorSelectionCollectionView.delegate = self
        colorSelectionCollectionView.backgroundColor = AppColors.backgroundAppColor
        
        contentView.addSubview(colorSelectionCollectionView)
        colorSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(carsColorLabel.snp.bottom).offset(10)
            make.leading.equalTo(carsColorLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    func setupTypeOfObstaclesLabel(){
        contentView.addSubview(typeOfObstaclesLabel)
        typeOfObstaclesLabel.snp.makeConstraints { make in
            make.top.equalTo(colorSelectionCollectionView.snp.bottom).offset(35)
            make.leading.equalTo(avatarImageView)
        }
    }
    
    func setupObstaclesSelectionCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        obstaclesSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        obstaclesSelectionCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        obstaclesSelectionCollectionView.dataSource = self
        obstaclesSelectionCollectionView.delegate = self
        obstaclesSelectionCollectionView.backgroundColor = AppColors.backgroundAppColor
        
        contentView.addSubview(obstaclesSelectionCollectionView)
        obstaclesSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(typeOfObstaclesLabel.snp.bottom).offset(10)
            make.leading.equalTo(typeOfObstaclesLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    func setupDifficultyLabel(){
        contentView.addSubview(difficultyLabel)
        difficultyLabel.snp.makeConstraints { make in
            make.top.equalTo(obstaclesSelectionCollectionView.snp.bottom).offset(35)
            make.leading.equalTo(avatarImageView)
        }
    }
    
    func setupDifficultySelectionCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        difficultyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        difficultyCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        difficultyCollectionView.dataSource = self
        difficultyCollectionView.delegate = self
        difficultyCollectionView.backgroundColor = AppColors.backgroundAppColor
        
        contentView.addSubview(difficultyCollectionView)
        difficultyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(difficultyLabel.snp.bottom).offset(10)
            make.leading.equalTo(difficultyLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func setupSaveSettingsButton() {
        contentView.addSubview(saveSettingsButton)
        saveSettingsButton.snp.makeConstraints { make in
            make.top.equalTo(difficultyCollectionView.snp.bottom).offset(45)
            make.centerX.equalTo(contentView)
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualTo(contentView).inset(20) // Дополнительно: добавьте нижний отступ, чтобы обеспечить прокрутку до кнопки
        }
        saveSettingsButton.addTarget(self, action: #selector(saveSettingsButtonTapped), for: .touchUpInside)
    }
    
    func printSettings() {
        if let data = UserDefaults.standard.data(forKey: "settings"),
           let settings = try? JSONDecoder().decode(Settings.self, from: data) {
            print("User Name: \(settings.userName)")
            print("Car Color Index: \(settings.carColorIndex)")
            print("Obstacle Type Index: \(settings.obstacleTypeIndex)")
            print("Difficulty Index: \(settings.difficultyIndex)")
        }
    }
    
    init(presenter: SettingsScreenPresenterProtocol) {
        self.settingsPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            avatarImageView.image = editedImage
            // Сохраняем изображение в формате Data
            if let imageData = editedImage.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(imageData, forKey: "avatarImageData")
            }
        } else if let originalImage = info[.originalImage] as? UIImage {
            avatarImageView.image = originalImage
            // Сохраняем изображение в формате Data
            if let imageData = originalImage.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(imageData, forKey: "avatarImageData")
            }
        }
        dismiss(animated: true)
    }
}

extension SettingsScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SettingsScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        switch collectionView{
        case colorSelectionCollectionView:
            cell.backgroundColor = colorsArray[indexPath.item]
            cell.layer.borderWidth = selectedColorIndex == indexPath.item ? 3 : 0
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 20
        case obstaclesSelectionCollectionView:
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: obstaclesArray[indexPath.item])
            cell.contentView.addSubview(imageView)
            cell.layer.borderWidth = selectedObstaclesIndex == indexPath.item ? 3 : 0
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 20
        case difficultyCollectionView:
            cell.backgroundColor = .lightGray
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: 20))
            label.text = difficultyArray[indexPath.item]
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .black
            cell.contentView.addSubview(label)
            cell.layer.borderWidth = selectedDifficultyIndex == indexPath.item ? 3 : 0
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 20
        default:
            print("Error cell")
        }
        
        return cell
    }
    
    func saveSettings() {
        let settings = Settings(
            userName: nameTextField.text ?? "",
            carColorIndex: selectedColorIndex,
            obstacleTypeIndex: selectedObstaclesIndex,
            difficultyIndex: selectedDifficultyIndex,
            avatarImageData: avatarImageView.image?.jpegData(compressionQuality: 0.8)
        )
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(settings)
            UserDefaults.standard.set(data, forKey: "settings")
        } catch {
            print("Error saving settings: \(error)")
        }
    }
    
    @objc func saveSettingsButtonTapped() {
        saveSettings()
        printSettings()
    }
}

extension SettingsScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
        case colorSelectionCollectionView:
            selectedColorIndex = indexPath.item // Сохраните выбранный индекс
            print("Выбрали 1 \(selectedColorIndex)")
            collectionView.reloadData() // Перезагрузите коллекцию, чтобы обновить внешний вид ячеек
        case obstaclesSelectionCollectionView:
            selectedObstaclesIndex = indexPath.item // Сохраните выбранный индекс
            print("Выбрали 2 \(selectedObstaclesIndex)")
            collectionView.reloadData() // Перезагрузите коллекцию, чтобы обновить внешний вид ячеек
        case difficultyCollectionView:
            selectedDifficultyIndex = indexPath.item // Сохраните выбранный индекс
            print("Выбрали 3 \(selectedDifficultyIndex)")
            collectionView.reloadData() // Перезагрузите коллекцию, чтобы обновить внешний вид ячеек
        default:
            print("Error didSelectItemAt collectionView")
        }
    }
}

extension SettingsScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
