//
//  ReportAPI.swift
//  DOR
//
//  Created by 황상환 on 1/17/25.
//

import Foundation
import Moya

enum ReportAPI {
    case submitReport(text: String, image: Data?, array: [Int])
}

extension ReportAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://주소.com")! // 실제 API URL로 변경
    }
    
    var path: String {
        switch self {
        case .submitReport:
            return "/report"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case let .submitReport(text, image, array):
            var formData: [MultipartFormData] = [
                MultipartFormData(provider: .data(text.data(using: .utf8)!), name: "text"),
                MultipartFormData(provider: .data(arrayToString(array).data(using: .utf8)!), name: "array")
            ]
            if let image = image {
                formData.append(MultipartFormData(provider: .data(image), name: "image", fileName: "image.jpg", mimeType: "image/jpeg"))
            }
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "multipart/form-data"]
    }
    
    // 배열을 JSON 문자열로 변환
    private func arrayToString(_ array: [Int]) -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []) else {
            return "[]"
        }
        return String(data: jsonData, encoding: .utf8) ?? "[]"
    }
}
