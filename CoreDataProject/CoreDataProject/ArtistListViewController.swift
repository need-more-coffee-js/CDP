//
//  ArtistListViewController.swift
//  CoreDataProject
//
//  Created by Денис Ефименков on 14.02.2025.
//

import UIKit
import CoreData
import SnapKit

class ArtistListViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    private var tableView: UITableView!
    private var fetchedResultsController: NSFetchedResultsController<Artist>!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFetchedResultsController()
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "Исполнители"
        view.backgroundColor = .white

        // Кнопка добавления
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addArtist)
        )

        // Таблица
        tableView = UITableView()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)

        // Верстка с SnapKit
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Core Data
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Ошибка при загрузке данных: \(error)")
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let artist = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(artist.firstName ?? "") \(artist.lastName ?? "")"
        cell.detailTextLabel?.text = "Страна: \(artist.country ?? ""), Дата рождения: \(artist.birthDay?.formatted() ?? "")"
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Логика перехода на другой экран
    }


    // MARK: - Actions
    @objc private func addArtist() {
        let addArtistVC = AddArtistViewController()
        navigationController?.pushViewController(addArtistVC, animated: true)
    }
}
