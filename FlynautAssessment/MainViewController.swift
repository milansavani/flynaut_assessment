//
//  MainViewController.swift
//  FlynautAssessment
//
//  Created by iMac on 24/04/23.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Lifecycle Actions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    
    /// Navigate to the Story feature
    /// - Parameter sender: StoryButton
    @IBAction func tapStoryButton(_ sender: Any) {
        DispatchQueue.main.async {
            let storyVC = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifier.StoryVC) as! StoryVC
            storyVC.modalPresentationStyle = .overFullScreen
            self.present(storyVC, animated: true, completion: nil)
        }
    }
    
    /// Navigate to Movielist
    /// - Parameter sender: MovieButton
    @IBAction func tapMovieButton(_ sender: Any) {
        
        let movieListVC = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifier.MovieListVC) as! MovieListVC
        self.navigationController?.pushViewController(movieListVC, animated: true)
    }
    
}

