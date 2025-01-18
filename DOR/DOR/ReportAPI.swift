//
//  ReportAPI.swift
//  DOR
//
//  Created by 황상환 on 1/17/25.
//

import Foundation
import Moya

enum ReportAPI {
    case submitReport(text: String, image: Data?)
    case getDangerLevel
    case getReportDetail(id: Int)
}

extension ReportAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://192.168.0.18:5000")!
    }
    
    var path: String {
        switch self {
        case .submitReport:
            return "/upload"
        case .getDangerLevel:
            return "/images/1/risk"
        case .getReportDetail(let id):
                return "/images/1"
        }
    }

    var method: Moya.Method {
        switch self {
        case .submitReport:
            return .post
        case .getDangerLevel, .getReportDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .submitReport(text, image):
            var formData: [MultipartFormData] = [
                MultipartFormData(provider: .data(text.data(using: .utf8)!), name: "report_text"),
            ]
            if let image = image {
                formData.append(MultipartFormData(provider: .data(image), name: "image", fileName: "image.jpg", mimeType: "image/jpeg"))
            }
            return .uploadMultipart(formData)
        case .getDangerLevel, .getReportDetail:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .submitReport:
            return ["Content-Type": "multipart/form-data"]
        case .getDangerLevel, .getReportDetail:
            return ["Content-Type": "application/json"]
        }
    }
    
    private func arrayToString(_ array: [Int]) -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []) else {
            return "[]"
        }
        return String(data: jsonData, encoding: .utf8) ?? "[]"
    }
}
