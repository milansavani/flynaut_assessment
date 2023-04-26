//
//  MovieListCell.swift
//  FlynautAssessment
//
//  Created by iMac on 24/04/23.
//

import UIKit
import Kingfisher
protocol MovieListDelegate {
    func didTappedFavourite(isFavourite: Bool, model: MovieModel?, indexpath: IndexPath?)
}

class MovieListCell: UICollectionViewCell {
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!

    var indexPath: IndexPath?
    var model: MovieModel?
    var delegate: MovieListDelegate?

    // MARK: - Lifecycle Actions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @IBAction func didTapFavouriteButton(_ sender: Any) {
        let isFavourite = !(sender as! UIButton).isSelected
        delegate?.didTappedFavourite(isFavourite: isFavourite, model: model, indexpath: indexPath)
    }
    
    // MARK: - Custom Actions
    
    /// Configure Initial data in cell view
    /// - Parameter data: data
    func configureCell(for data: MovieModel) {
        model = data
        self.movieName.text = data.title
        movieImage.kf.setImage(with: URL(string: URLConstant.movieImageBaseURL + data.poster_path)!)
        if let isFavourite = data.isFavourite , isFavourite == true {
            favouriteButton.isSelected = true
            favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favouriteButton.isSelected = false
            favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)

        }
    }
    
}
