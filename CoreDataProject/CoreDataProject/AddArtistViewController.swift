//
//  AddArtistViewController.swift
//  CoreDataProject
//
//  Created by Денис Ефименков on 14.02.2025.
//

import UIKit
import CoreData
import SnapKit

class AddArtistViewController: UIViewController {
    // MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()
    private let countryTextField = UITextField()
    private let birthDayDatePicker = UIDatePicker()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "Добавить исполнителя"
        view.backgroundColor = .white

        // Поле для имени
        firstNameTextField.placeholder = "Имя"
        firstNameTextField.borderStyle = .roundedRect
        view.addSubview(firstNameTextField)

        // Поле для фамилии
        lastNameTextField.placeholder = "Фамилия"
        lastNameTextField.borderStyle = .roundedRect
        view.addSubview(lastNameTextField)

        // Поле для страны
        countryTextField.placeholder = "Страна"
        countryTextField.borderStyle = .roundedRect
        view.addSubview(countryTextField)

        // DatePicker для даты рождения
        birthDayDatePicker.datePickerMode = .date
        view.addSubview(birthDayDatePicker)

        // Кнопка сохранения
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveArtist), for: .touchUpInside)
        view.addSubview(saveButton)

        // Верстка с SnapKit
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        countryTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        birthDayDatePicker.snp.makeConstraints { make in
            make.top.equalTo(countryTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(birthDayDatePicker.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Actions
    @objc private func saveArtist() {
        let newArtist = Artist(context: context)
        newArtist.firstName = firstNameTextField.text
        newArtist.lastName = lastNameTextField.text
        newArtist.country = countryTextField.text
        newArtist.birthDay = birthDayDatePicker.date

        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Ошибка при сохранении: \(error)")
        }
    }
}
