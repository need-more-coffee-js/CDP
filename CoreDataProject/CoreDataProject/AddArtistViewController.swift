//
//  AddArtistViewController.swift
//  CoreDataProject
//
//  Created by Денис Ефименков on 14.02.2025.
//

import UIKit
import CoreData
import SnapKit

class AddArtistViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let artistListVC = ArtistListViewController()
    public let firstNameTextField = UITextField()
    public let lastNameTextField = UITextField()
    public let countryTextField = UITextField()
    public let birthDayDatePicker = UITextField()
    public let datePicker = UIDatePicker()


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
        birthDayDatePicker.keyboardType = .numberPad
        birthDayDatePicker.placeholder = "дд.мм.гггг"
        birthDayDatePicker.borderStyle = .roundedRect
        birthDayDatePicker.delegate = self
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
        if let dateString = birthDayDatePicker.text {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            if let date = formatter.date(from: dateString){
                newArtist.birthDay = date
            }else{
                print("wrong date")
            }
        }

        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Ошибка при сохранении: \(error)")
        }
    }
}

extension AddArtistViewController  {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Проверяем, что вводятся только цифры
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }

        // Текущий текст в UITextField
        guard let currentText = birthDayDatePicker.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        // Ограничиваем длину ввода (10 символов для дд.мм.гггг)
        if newText.count > 10 {
            return false
        }

        // Автоматическая вставка разделителей
        if newText.count == 2 || newText.count == 5 {
            textField.text = "\(newText)."
            return false
        }

        return true
    }
}
