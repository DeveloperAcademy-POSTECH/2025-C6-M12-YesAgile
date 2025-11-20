//
//  FoodLibrayView.swift
//  babyMoa
//
//  Created by Baba on 10/30/25.
//

import SwiftUI

struct FoodLibrayView: View {
    let item: FoodLibraryItem
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 15) {
                Text(item.category.icon)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    if let nutritionalInfo = item.nutritionalInfo {
                        Text(nutritionalInfo)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
