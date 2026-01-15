//
//  AnalyzeArgueRequest.swift
//  Aura
//
//  Created by Ezgi Özkan on 15.01.2026.
//

import Foundation
import Alamofire

struct AnalyzeArgueRequest {
    let imageData: Data
    var language: String = LanguageManager.shared.effectiveLanguageCode
    var fileName: String = "argue.png"
    var mimeType: String = "image/png"

    func append(to formData: MultipartFormData) {
        formData.append(imageData,
                        withName: "image",
                        fileName: fileName,
                        mimeType: mimeType)
        if let data = language.data(using: .utf8) {
            formData.append(data, withName: "language")
        }
    }
}
