//
//  CheckAuraRequest.swift
//  Aura
//
//  Created by Ezgi Özkan on 8.01.2026.
//

import Foundation
import Alamofire

struct CheckAuraRequest {
    let meImageData: Data
    let targetImageData: Data
    var meFileName: String = "me.png"
    var targetFileName: String = "target.png"

    var meMimeType: String = "image/png"
    var targetMimeType: String = "image/png"

    func append(to formData: MultipartFormData) {
        formData.append(meImageData,
                        withName: "me",
                        fileName: meFileName,
                        mimeType: meMimeType)

        formData.append(targetImageData,
                        withName: "target",
                        fileName: targetFileName,
                        mimeType: targetMimeType)
    }
}
