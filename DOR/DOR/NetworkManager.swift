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
    
    func submitReport(text: String, image: Data?, array: [Int], completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.submitReport(text: text, image: image, array: array)) { result in
            completion(result)
        }
    }
}
