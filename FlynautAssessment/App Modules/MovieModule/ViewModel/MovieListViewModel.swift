//
//  MovieListViewModel.swift
//  FlynautAssessment
//
//  Created by iMac on 24/04/23.
//

import Foundation
import UIKit

class MovieListViewModel {
    var movies: [MovieModel] = []
    var currentPage: Int = 0
    var totalPage: Int = 10
    var storedMovies: [Movie] = []

    // MARK: - Custom Actions
    
    /// Number of item in collection section
    /// - Parameter section: section
    /// - Returns: number of items
    func numberOfItemsInSection(_ section: Int) -> Int {
        return movies.count
    }
    
    /// Fetch movie based on index
    /// - Parameter indexpath: indexpath
    /// - Returns: Movie model
    func movieAt(indexpath: IndexPath) -> MovieModel {
        return movies[indexpath.row]
    }

    /// Fetch movie
    /// - Parameters:
    ///   - isLazy: isLazy
    ///   - onSuccess: onSuccess
    ///   - onFailure: onFailure
    func fetchMovies(isLazy: Bool = false, onSuccess: @escaping () -> Void, onFailure: @escaping FailureHandler) {
        self.currentPage+=1
        
        // API call
        APIManager.fetchMovieList(page: self.currentPage) { [weak self] data in
            // Append result to current list
            self?.movies.append(contentsOf: data.results)
            
            // Setup a movie object with the favorite data and if not found in the local storage than save it
            let filtered = self?.movies.map({ oldMovie -> MovieModel in
                var newMovie = oldMovie
                if let storedObj = self?.storedMovies.first(where: { $0.id == Int64(oldMovie.id)}) {
                    newMovie.isFavourite = storedObj.isfavourite
                } else {
                    let movie = DataManager.shared.movie(movieId: oldMovie.id, title: oldMovie.title, url: oldMovie.poster_path, isFavourite: false)
                    self?.storedMovies.append(movie)
                    DataManager.shared.save()
                }
                return newMovie
            })
            if let filtered = filtered {
                self?.movies = filtered
            }
            onSuccess()
        } onFailure: { errors in
            self.movies = self.storedMovies.map { mv -> MovieModel in
                return MovieModel(id: Int(mv.id), title: mv.title ?? "", poster_path: mv.url ?? "", isFavourite: mv.isfavourite)
            }
            onFailure(errors)
        }
    }
    
    /// Update movie in local storage
    /// - Parameters:
    ///   - movie: movie object
    ///   - index: index
    func updateMovie(movie: MovieModel, index: Int) {
        self.movies[index] = movie
        let stored = storedMovies.first(where: {$0.id == Int64(movie.id)})
        stored?.isfavourite = movie.isFavourite ?? false
        DataManager.shared.save()
    }
    
}

