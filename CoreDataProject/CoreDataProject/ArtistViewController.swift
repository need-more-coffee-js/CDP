
import Foundation
import UIKit
import SnapKit
import CoreData

class ArtistViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    private let viewModel = ArtistViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // Принудительное обновление таблицы
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
//MARK: - Setup ui elements
    func setupViews(){
        title = "Исполнители"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addArtist)
        )
        
        let menu = UIMenu(title: "Сортировка:", children: [
            UIAction(title: "в алфавитном порядке", image: UIImage(systemName: "arrow.down"), handler: { [self] _ in
                viewModel.sortAscending = true
                viewModel.setupFetchedResultsController()
                viewModel.saveSortingPreference()
                tableView.reloadData()
            }),
            UIAction(title: "в обратном алфавитном порядке", image: UIImage(systemName: "arrow.up"), handler: { [self] _ in
                viewModel.sortAscending = false
                viewModel.setupFetchedResultsController()
                viewModel.saveSortingPreference()
                tableView.reloadData()
            })
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .bookmarks,
            menu: menu
        )
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
    }
  
    private func setupViewModel() {
        viewModel.onDataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.fetchedResultsController.delegate = self
    }
    
    @objc private func addArtist() {
        let detailVC = ArtistDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfArtists()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let artist = viewModel.artist(at: indexPath.row)
        cell.mainLabel.text = artist.value(forKeyPath: "lastName") as? String
        cell.profileImageView.image = UIImage(named: "countryImage")
        cell.countryLabel.text = artist.value(forKeyPath: "country") as? String
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = viewModel.artist(at: indexPath.row)
        let detailVC = ArtistDetailViewController()
        detailVC.artist = artist
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем элемент из Core Data
            let artist = viewModel.artist(at: indexPath.row)
            viewModel.deleteArtist(artist)
            tableView.reloadData()
        }
    }
    //MARK: - методы делегата не вызываются, но оставил для наглядности. Может потом дойдет почему не работают
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("begin")
        tableView.beginUpdates()
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
            fatalError("Unknown change type")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("end")
        tableView.endUpdates()
    }
}
