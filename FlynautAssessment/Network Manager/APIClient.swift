//
//
//  APIClient.swift
//  FlynautAssessment
//
//  Created by iMac on 25/04/23.
//
import Foundation

typealias SuccessHandler<T: Codable> = (T) -> Void
typealias FailureHandler = (Error) -> Void

/// It contains all required resource for the webservice request
struct RequestResource<T: Codable> {
    var url: String
    var parameters: [String: String]?
    var extraHeaders: [String: String]?
}

/// It describe the type of error while calling webservices
enum APIClientError: Error {
    case nodata, jsonserialisation
}

/// APIClient class handles webservice's requests and responses.
final class APIClient {
    static let shared = APIClient()
    private init() {
    }
}

extension APIClient {
    // GET API Call
    func performGetAPI<T>(with resource: RequestResource<T>, onSuccess: @escaping SuccessHandler<T>, onFailure: @escaping FailureHandler) {

        guard let components = URLComponents(string: resource.url) else { return }
        guard let url = components.url else { return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        resource.extraHeaders?.forEach({ (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        })
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    onFailure(error!)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    onFailure(APIClientError.nodata)
                }
                return
            }

            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                DispatchQueue.main.async {
                    onFailure(APIClientError.jsonserialisation)
                }
                return
            }
            DispatchQueue.main.async {
                onSuccess(result)
            }
        }
        task.resume()
    }
}
