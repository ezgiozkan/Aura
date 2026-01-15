//
//  GenerateRizzRequest.swift
//  Aura
//
//  Created by Ezgi Özkan on 8.01.2026.
//

import Foundation
import Alamofire

struct GenerateRizzRequest {
    let imageData: Data
    let imageFileName: String
    let imageMimeType: String
    let extraContext: String?
    let language: String

    init(imageData: Data,
         imageFileName: String = "image.png",
         imageMimeType: String = "image/png",
         extraContext: String? = nil,
         language: String = LanguageManager.shared.effectiveLanguageCode) {
        self.imageData = imageData
        self.imageFileName = imageFileName
        self.imageMimeType = imageMimeType
        self.extraContext = extraContext
        self.language = language
    }

    func queryParameters() -> Parameters {
        var params: Parameters = [:]
        if let extraContext, extraContext.isEmpty == false {
            params["extra_context"] = extraContext
        }
        params["language"] = language
        return params
    }

    func appendMultipart(to multipart: MultipartFormData) {
        multipart.append(imageData,
                         withName: "image",
                         fileName: imageFileName,
                         mimeType: imageMimeType)

        if let languageData = language.data(using: .utf8) {
            multipart.append(languageData, withName: "language")
        }
    }
}
