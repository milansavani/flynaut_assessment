//
//  DataManager.swift
//  FlynautAssessment
//
//  Created by iMac 25/04/23.
//

import Foundation
import CoreData

class DataManager {
    
    /// Singleton
    static let shared = DataManager()
    
    /// Retrieve a persistent storage for application
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FlynautAssessment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Custom Actions
    
    /// Setup movie to save in the local storage
    /// - Parameters:
    ///   - movieId: movieId
    ///   - title: title
    ///   - url: profileImageURL
    ///   - isFavourite: isFavourite
    /// - Returns: Movie Object
    func movie(movieId: Int, title: String, url: String, isFavourite: Bool) -> Movie {
        let movie = Movie(context: persistentContainer.viewContext)
        movie.title = title
        movie.id = Int64(movieId)
        movie.url = url
        movie.isfavourite = isFavourite
        return movie
    }

    /// Fetch movie from local storage
    /// - Returns: List of movies
    func storedMovies() -> [Movie] {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        var fetchedMovies: [Movie] = []
        
        do {
            fetchedMovies = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedMovies
    }
    
    
    
    /// Save data into the local storage
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("❗️Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
