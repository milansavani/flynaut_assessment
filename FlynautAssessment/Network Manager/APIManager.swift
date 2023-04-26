//
//  APIManager.swift
//  FlynautAssessment
//
//  Created by iMac on 25/04/23.
//

import Foundation

class APIManager {
    static func fetchMovieList(page: Int, onSuccess: @escaping (MovieData) -> Void, onFailure: @escaping FailureHandler) {
        // Manupualte URL String
        let urlString = URLConstant.BASEURL + APIEndPoint.movieList + "&page=\(page)"
        let resource = RequestResource<MovieData>(url: urlString)
        
        // API Call
        APIClient.shared.performGetAPI(with: resource, onSuccess: onSuccess, onFailure: onFailure)
    }
}
