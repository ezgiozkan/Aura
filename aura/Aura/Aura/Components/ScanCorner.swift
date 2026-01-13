//
//  ScanCorner.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI

struct ScanCorner: View {
    enum Position {
        case topLeft, topRight, bottomLeft, bottomRight
    }

    let position: Position

    var body: some View {
        ZStack {
            switch position {
            case .topLeft:
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle().frame(width: 30, height: 4)
                    Rectangle().frame(width: 4, height: 30)
                }
            case .topRight:
                VStack(alignment: .trailing, spacing: 0) {
                    Rectangle().frame(width: 30, height: 4)
                    HStack {
                        Spacer()
                        Rectangle().frame(width: 4, height: 30)
                    }
                }
            case .bottomLeft:
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle().frame(width: 4, height: 30)
                    Rectangle().frame(width: 30, height: 4)
                }
            case .bottomRight:
                VStack(alignment: .trailing, spacing: 0) {
                    HStack {
                        Spacer()
                        Rectangle().frame(width: 4, height: 30)
                    }
                    Rectangle().frame(width: 30, height: 4)
                }
            }
        }
        .foregroundStyle(Color.purple)
    }
}
