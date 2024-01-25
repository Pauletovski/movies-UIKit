//
//  NetworkManager.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import Foundation
import Moya

protocol Networkable {
    var networkRequest: MoyaProvider<NetworkRequest> { get }
    func getMovies(page: Int) async -> Result<Movies, CustomError>
    func getMovieDetails(id: Int) async -> Result<MovieDetails, CustomError>
    func getGenreList() async -> Result<[Genre], CustomError>
}

class NetworkManager: Networkable {
    
    var networkRequest = MoyaProvider<NetworkRequest>()
    
    func getMovies(page: Int) async -> Result<Movies, CustomError> {
        await networkRequest.requestModel(.getMovies(page: 1), Movies.self)
    }
    
    func getMovieDetails(id: Int) async -> Result<MovieDetails, CustomError> {
        await networkRequest.requestModel(.getDetails(id: id), MovieDetails.self)
    }
    
    func getGenreList() async -> Result<[Genre], CustomError> {
        await networkRequest.requestModel(.getGenre, [Genre].self)
    }
}

public enum CustomError: Error {
    case objectDeallocated, parsingError, networkError
}


// MARK: - Generic Combine Request
extension MoyaProvider {
    func requestAsync(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func requestModel<T: Decodable>(_ target: Target, _: T.Type) async -> Result<T, CustomError> {
        do {
            let response = try await self.requestAsync(target)
            let result = try JSONDecoder().decode(T.self, from: response.data)
            return .success(result)
        } catch {
            print(error.localizedDescription)
            return .failure(CustomError.networkError)
        }
    }
}




// MARK: - Generic Combine Request
//public extension MoyaProvider {
//    func requestModel<T: Decodable>(_ target: Target, responseType: T.Type) -> AnyPublisher<Result<T, CustomError>, Never> {
//        return Future { promise in
//            self.request(target) { result in
//                switch result {
//                case .success(let response):
//                    do {
//                        let decodedData = try JSONDecoder().decode(T.self, from: response.data)
//                        promise(.success(.success(decodedData)))
//                    } catch {
//                        promise(.success(.failure(.parsingError)))
//                    }
//
//                case .failure(_):
//                    promise(.success(.failure(.networkError)))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    func request(_ target: Target) -> AnyPublisher<Result<Void, CustomError>, Never> {
//        return Future { promise in
//            self.request(target) { result in
//                switch result {
//                case .success(_):
//                    promise(.success(.success(())))
//                case .failure(_):
//                    promise(.success(.failure(.networkError)))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}
