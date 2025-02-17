//
//  ArtistListViewController.swift
//  CoreDataProject
//
//  Created by Денис Ефименков on 14.02.2025.
//

import UIKit
import CoreData
import SnapKit

class ArtistListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    private var tableView: UITableView!
    private var fetchedResultsController: NSFetchedResultsController<Artist>!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let sortKey = "lastName" // Ключ сортировки
    private var sortAscending = true // Направление сортировки
    var artists : [Artist] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSortingPreference() //сначала загружаем параметры сортировки
        setupFetchedResultsController() // затем уже выгружаем данные artists
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "Исполнители"
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addArtist)
        )

        let menu = UIMenu(title: "Сортировка:", children: [
            UIAction(title: "в алфавитном порядке", image: UIImage(systemName: "arrow.down"), handler: { [self] _ in
                sortAscending = true
                saveSortingPreference()
                setupFetchedResultsController()
                tableView.reloadData()
            }),
            UIAction(title: "в обратном алфавитном порядке", image: UIImage(systemName: "arrow.up"), handler: { [self] _ in
                sortAscending = false
                saveSortingPreference()
                setupFetchedResultsController()
                tableView.reloadData()
            })
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .bookmarks,
            menu: menu
        )

        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Sort settings using UserDefaults
    private let sortingKey = "sortingPreference"

    func saveSortingPreference() {
        UserDefaults.standard.set(sortAscending, forKey: sortingKey)
    }

    func loadSortingPreference() {
        sortAscending = UserDefaults.standard.bool(forKey: sortingKey)
    }


    // MARK: - Core Data
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: sortAscending)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Ошибка при загрузке данных: \(error)")
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let artist = fetchedResultsController.object(at: indexPath)
        cell.mainLabel.text = "\(artist.firstName ?? "empty") \(artist.lastName ?? "empty")"
        cell.countryLabel.text = artist.country
        cell.profileImageView.image = UIImage(named: "countryImage")
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let artistToDelete = fetchedResultsController.object(at: indexPath)
            context.delete(artistToDelete)
        }
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении после удаления: \(error)")
        }

        tableView.reloadData()

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    tableView.moveRow(at: indexPath, to: newIndexPath)
                }
            @unknown default:
                fatalError("Неизвестный тип изменения")
            }
        }


    // MARK: - Actions
    @objc private func addArtist() {
        let addArtistVC = AddArtistViewController()
        navigationController?.pushViewController(addArtistVC, animated: true)
    }
}
