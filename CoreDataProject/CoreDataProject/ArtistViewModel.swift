//
//  ArtistViewModel.swift
//  CoreDataProject
//
//  Created by Денис Ефименков on 18.02.2025.
//

import Foundation
import CoreData
import UIKit

class ArtistViewModel: NSObject, NSFetchedResultsControllerDelegate{
    public var fetchedResultsController: NSFetchedResultsController<Artist>!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var onDataChanged: (()-> Void)?
    public var sortKey = "lastName"
    public var sortAscending = true
    
    override init() {
        super.init()
        loadSortingPreference()
        setupFetchedResultsController()
    }
    
    public func setupFetchedResultsController(){
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
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
    
    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onDataChanged?()
    }

    // Получение количества элементов
    func numberOfArtists() -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    // Получение элемента по индексу
    func artist(at index: Int) -> NSManagedObject {
        return fetchedResultsController.object(at: IndexPath(row: index, section: 0))
    }
    
    func saveArtist(lastName: String, firstName:String, country: String, birthDay: Date, artist: NSManagedObject? = nil){
        if let artist = artist{
            artist.setValue(lastName, forKey:"lastName")
            artist.setValue(firstName, forKey:"firstName")
            artist.setValue(country, forKey:"country")
            artist.setValue(birthDay, forKey:"birthDay")
        }else{
            let newArtist = Artist(context: context)
            newArtist.setValue(lastName, forKey:"lastName")
            newArtist.setValue(firstName, forKey:"firstName")
            newArtist.setValue(country, forKey:"country")
            newArtist.setValue(birthDay, forKey:"birthDay")
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteArtist(_ artist: NSManagedObject){
        context.delete(artist)
        do {
            try context.save() // Сохраняем изменения
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
