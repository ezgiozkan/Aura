//
//  CustomTabBar.swift
//  Aura
//
//  Created by Ezgi Özkan on 9.01.2026.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let tabWidth = geometry.size.width / CGFloat(TabItem.allCases.count)
                let selectedIndex = CGFloat(selectedTab.rawValue)

                Rectangle()
                    .fill(.white)
                    .frame(width: tabWidth * 0.6, height: 3)
                    .cornerRadius(1.5)
                    .offset(x: tabWidth * selectedIndex + tabWidth * 0.2)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
            }
            .frame(height: 3)
            .padding(.horizontal, 16)

            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    TabBarItem(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(
                Color(white: 0.12)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }
}
