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
    
    private var colorSelectionCollectionView: UICollectionView!
    private var selectedColorIndex = 1
    private var selectedObstaclesIndex = 1
    private var selectedDifficultyIndex = 2
    private let colorsArray = [AppColors.redCar, AppColors.brownCar, AppColors.yellowCar]
    private var obstaclesSelectionCollectionView: UICollectionView!
    private let obstaclesArray = ["kust", "palm", "tree"]
    private var difficultyCollectionView: UICollectionView!
    private let difficultyArray = ["easy", "medium", "hard"]
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColors.defaultAvatarImageAppColor
        imageView.layer.cornerRadius = LayoutConstants.Settings.imageCornerRadius
        imageView.image = UIImage(named: "avatar")
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let imagePicker = UIImagePickerController() // ??
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = FontConstants.labelFont
        label.textColor = AppColors.textColor
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "SuperUser"
        textField.borderStyle = .roundedRect
        textField.font = FontConstants.labelFont
        textField.textColor = AppColors.textColor
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let carsColorLabel: UILabel = {
        let label = UILabel()
        label.text = "Cars color"
        label.font = FontConstants.labelFont
        label.textColor = AppColors.textColor
        return label
    }()
    
    private let typeOfObstaclesLabel: UILabel = {
        let label = UILabel()
        label.text = "Type of obstacles"
        label.font = FontConstants.labelFont
        label.textColor = AppColors.textColor
        return label
    }()
    
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.text = "Difficulty"
        label.font = FontConstants.labelFont
        label.textColor = AppColors.textColor
        return label
    }()
    
    private let saveSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Settings", for: .normal)
        button.titleLabel?.font = FontConstants.buttonFont
        button.backgroundColor = AppColors.buttonAppColor
        button.setTitleColor(AppColors.buttonTextAppColor, for: .normal)
        button.layer.cornerRadius = LayoutConstants.standartCornerRadius
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.backgroundAppColor
        setupUI()
        loadSettings()
        navigationController?.isNavigationBarHidden = false
    }
    private func setupUI(){
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.left.right.bottom.width.equalTo(scrollView)
        }
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(carsColorLabel)
        contentView.addSubview(typeOfObstaclesLabel)
        contentView.addSubview(difficultyLabel)
        contentView.addSubview(saveSettingsButton)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(LayoutConstants.standardMargin)
            make.left.equalTo(contentView.snp.left).offset(LayoutConstants.standardMargin)
            make.width.height.equalTo(LayoutConstants.Settings.avatarImageViewWidth)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        avatarImageView.addGestureRecognizer(tapGesture)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(LayoutConstants.standardMargin)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(LayoutConstants.standardMargin)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(LayoutConstants.standardMargin)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.equalTo(LayoutConstants.Settings.nameTextFieldWidth)
            make.height.equalTo(LayoutConstants.Settings.nameTextFieldHeight)
        }
        nameTextField.delegate = self
        
        carsColorLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(LayoutConstants.standardMargin)
            make.leading.equalTo(avatarImageView)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: LayoutConstants.Settings.collectionViewHeight,
            height: LayoutConstants.Settings.collectionViewHeight
        )
        
        colorSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colorSelectionCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        colorSelectionCollectionView.dataSource = self
        colorSelectionCollectionView.delegate = self
        colorSelectionCollectionView.backgroundColor = AppColors.backgroundAppColor
        
        contentView.addSubview(colorSelectionCollectionView)
        colorSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(carsColorLabel.snp.bottom).offset(LayoutConstants.standardMargin)
            make.leading.equalTo(carsColorLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(LayoutConstants.Settings.collectionViewHeight)
        }
        
        typeOfObstaclesLabel.snp.makeConstraints { make in
            make.top.equalTo(colorSelectionCollectionView.snp.bottom).offset(LayoutConstants.standardMargin)
            make.leading.equalTo(avatarImageView)
        }
        
        obstaclesSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        obstaclesSelectionCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        obstaclesSelectionCollectionView.dataSource = self
        obstaclesSelectionCollectionView.delegate = self
        obstaclesSelectionCollectionView.backgroundColor = AppColors.backgroundAppColor
        
        contentView.addSubview(obstaclesSelectionCollectionView)
        obstaclesSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(typeOfObstaclesLabel.snp.bottom).offset(LayoutConstants.standardMargin)
            make.leading.equalTo(typeOfObstaclesLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(LayoutConstants.Settings.collectionViewHeight)
        }
        
        difficultyLabel.snp.makeConstraints { make in
            make.top.equalTo(obstaclesSelectionCollectionView.snp.bottom).offset(LayoutConstants.standardMargin)
            make.leading.equalTo(avatarImageView)
        }
        
        difficultyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        difficultyCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        difficultyCollectionView.dataSource = self
        difficultyCollectionView.delegate = self
        difficultyCollectionView.backgroundColor = AppColors.backgroundAppColor
        
        contentView.addSubview(difficultyCollectionView)
        difficultyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(difficultyLabel.snp.bottom).offset(LayoutConstants.standardMargin)
            make.leading.equalTo(difficultyLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(LayoutConstants.Settings.collectionViewHeight)
        }
        
        saveSettingsButton.snp.makeConstraints { make in
            make.top.equalTo(difficultyCollectionView.snp.bottom).offset(LayoutConstants.standardMargin)
            make.centerX.equalTo(contentView)
            make.width.equalTo(LayoutConstants.Settings.buttonWidth)
            make.height.equalTo(LayoutConstants.Settings.buttonHeight)
            make.bottom.equalTo(contentView).inset(LayoutConstants.standardMargin)
        }
        saveSettingsButton.addTarget(self, action: #selector(saveSettingsButtonTapped), for: .touchUpInside)
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "settings"),
           let settings = try? JSONDecoder().decode(Settings.self, from: data) {
            nameTextField.text = settings.userName
            selectedColorIndex = settings.carColorIndex
            selectedObstaclesIndex = settings.obstacleTypeIndex
            selectedDifficultyIndex = settings.difficultyIndex
            colorSelectionCollectionView.reloadData()
            obstaclesSelectionCollectionView.reloadData()
            difficultyCollectionView.reloadData()

            if let avatarImageData = UserDefaults.standard.data(forKey: "avatarImageData") {
                avatarImageView.image = UIImage(data: avatarImageData)
            }
        }
    }
    
    @objc private func presentImagePicker() {
        present(imagePicker, animated: true)
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
            if let imageData = editedImage.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(imageData, forKey: "avatarImageData")
            }
        } else if let originalImage = info[.originalImage] as? UIImage {
            avatarImageView.image = originalImage
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
            cell.layer.borderWidth = selectedColorIndex == indexPath.item ? LayoutConstants.Settings.borderWidth : 0
            cell.layer.borderColor = AppColors.borderColor.cgColor
            cell.layer.cornerRadius = LayoutConstants.standartCornerRadius
        case obstaclesSelectionCollectionView:
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: obstaclesArray[indexPath.item])
            cell.contentView.addSubview(imageView)
            cell.layer.borderWidth = selectedObstaclesIndex == indexPath.item ? LayoutConstants.Settings.borderWidth : 0
            cell.layer.borderColor = AppColors.borderColor.cgColor
            cell.layer.cornerRadius = LayoutConstants.standartCornerRadius
        case difficultyCollectionView:
            cell.backgroundColor = .lightGray
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: 20))
            label.text = difficultyArray[indexPath.item]
            label.textAlignment = .center
            label.font = FontConstants.labelFont
            label.textColor = AppColors.textColor
            cell.contentView.addSubview(label)
            cell.layer.borderWidth = selectedDifficultyIndex == indexPath.item ? LayoutConstants.Settings.borderWidth : 0
            cell.layer.borderColor = AppColors.borderColor.cgColor
            cell.layer.cornerRadius = LayoutConstants.standartCornerRadius
        default:
            print("Error cell")
        }
        
        return cell
    }
    
    func saveSettings() {
        settingsPresenter.saveSettings(userName: nameTextField.text ?? "", carColorIndex: selectedColorIndex, obstacleTypeIndex: selectedObstaclesIndex, difficultyIndex: selectedDifficultyIndex, avatarImageData: avatarImageView.image?.jpegData(compressionQuality: 0.8))
        
        settingsPresenter.updateCurrentUser(name: nameTextField.text ?? "", userId: 79, image: avatarImageView.image?.jpegData(compressionQuality: 0.8))
    }

    
    @objc func saveSettingsButtonTapped() {
        saveSettings()
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SettingsScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
        case colorSelectionCollectionView:
            selectedColorIndex = indexPath.item
            collectionView.reloadData()
        case obstaclesSelectionCollectionView:
            selectedObstaclesIndex = indexPath.item
            collectionView.reloadData()
        case difficultyCollectionView:
            selectedDifficultyIndex = indexPath.item
            collectionView.reloadData()
        default:
            print("Error didSelectItemAt collectionView")
        }
    }
}

extension SettingsScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.Settings.minimumLineSpacingForSection
    }
}
