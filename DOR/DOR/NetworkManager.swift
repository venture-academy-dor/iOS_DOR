//
//  NetworkManager.swift
//  DOR
//
//  Created by 황상환 on 1/17/25.
//

import Foundation
import Moya

class NetworkManager {
    private let provider = MoyaProvider<ReportAPI>()

    func submitReport(text: String, image: Data?, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.submitReport(text: text, image: image)) { result in
            completion(result)
        }
    }
    
    func fetchDangerLevel(completion: @escaping (Result<Int, Error>) -> Void) {
        provider.request(.getDangerLevel) { result in
            switch result {
            case .success(let response):
                do {
                    let dangerResponse = try response.map(DangerLevelResponse.self)
                    completion(.success(dangerResponse.risk))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchReportDetail(id: Int, completion: @escaping (Result<ReportDetail, Error>) -> Void) {
        provider.request(.getReportDetail(id: id)) { result in
            switch result {
            case .success(let response):
                if let responseString = String(data: response.data, encoding: .utf8) {
                    print("Server Response: \(responseString)")
                }
                do {
                    let reportDetail = try response.map(ReportDetail.self)
                    completion(.success(reportDetail))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
