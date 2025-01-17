//
//  ReportDetail.swift
//  DOR
//
//  Created by 황상환 on 1/17/25.
//

import Foundation

struct ReportDetail: Codable {
    let imageUrl: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case content = "report_text"  
    }
}
