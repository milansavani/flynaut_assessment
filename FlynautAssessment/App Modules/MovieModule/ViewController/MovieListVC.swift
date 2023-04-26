//
//  MovieListVC.swift
//  FlynautAssessment
//
//  Created by iMac on 24/04/23.
//

import UIKit

class MovieListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = MovieListViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        // set navigation title
        self.title = "Movies"
        super.viewDidLoad()
        
        // Fetch data from local storage
        viewModel.storedMovies = DataManager.shared.storedMovies()
        
        // Setup Collection view layout
        setupCollectionViewLayout()
        
        // Api call to fetch data from movie database
        fetchMoviesData()
    }
    
    // MARK: - API Actions
    
    /// Fetch movie data
    /// - Parameter isLazy: isLazy
    func fetchMoviesData(isLazy: Bool = false) {
        if !isLazy {
            // Show actiivity indicator
            self.showLoader()
        }
        viewModel.fetchMovies { [weak self] in
            // Reload collectionview
            self?.collectionView.reloadData()
            
            // Hide actiivity indicator
            self?.hideLoader()
        } onFailure: { [weak self] errors in
            // Reload collectionview
            self?.collectionView.reloadData()
            
            // Hide actiivity indicator
            self?.hideLoader()
        }
    }
 
    // MARK: - Custom Actions
    
    /// Setup collectionview layout
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate Actions
extension MovieListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Initiate and Configure collection cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.movieListCell, for: indexPath)as? MovieListCell else {
            fatalError("MovieListCell Not found")
        }
        cell.delegate = self
        cell.indexPath = indexPath
        
        let movieData = viewModel.movieAt(indexpath: indexPath)
        cell.configureCell(for: movieData)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Setup collection cell size
        let cellWidth = UIScreen.main.bounds.width * 0.41 // It's magic number to display two cell in the screen
        return CGSize(width: cellWidth, height: cellWidth * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Lazy loading logic
        if indexPath.row == (self.viewModel.movies.count - 2) && self.viewModel.currentPage < AppConstant.maxPage {
                fetchMoviesData(isLazy: true)
        }
    }
}
// MARK: - CollectionCellDelegate Actions
extension MovieListVC: MovieListDelegate {
    func didTappedFavourite(isFavourite: Bool, model: MovieModel?, indexpath: IndexPath?) {
        // Setup updated model to save data in the local storage and reload collectionview item at indexPath
        var updatedModel = model
        updatedModel?.isFavourite = isFavourite
        guard let updatedModel = updatedModel, let indexPath = indexpath else {
            return
        }
        
        //Update movie in the local storage
        viewModel.updateMovie(movie: updatedModel, index: indexPath.item)
        collectionView.reloadItems(at: [indexPath])
    }
}
