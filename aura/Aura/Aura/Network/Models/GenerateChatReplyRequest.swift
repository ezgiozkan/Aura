//
//  GenerateChatReplyRequest.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import Foundation
import Alamofire

struct GenerateChatReplyRequest {
    let imageData: Data
    let imageFileName: String
    let imageMimeType: String
    let extraContext: String?
    let tone: String
    let language: String
    
    func appendMultipart(to multipartFormData: MultipartFormData) {
        multipartFormData.append(
            imageData,
            withName: "image",
            fileName: imageFileName,
            mimeType: imageMimeType
        )
        
        if let extraContext = extraContext,
           !extraContext.isEmpty,
           let contextData = extraContext.data(using: .utf8) {
            multipartFormData.append(
                contextData,
                withName: "extra_context"
            )
        }
        
        if let toneData = tone.data(using: .utf8) {
            multipartFormData.append(
                toneData,
                withName: "tone"
            )
        }
    }
}
