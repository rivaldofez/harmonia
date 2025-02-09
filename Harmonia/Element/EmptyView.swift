//
//  EmptyView.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import SwiftUI

struct EmptyView: View {
    var message: String = "There is no data from your request, please try with another"
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "shippingbox.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text(message)
                .font(.title2)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    EmptyView()
}
