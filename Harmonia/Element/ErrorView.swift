//
//  ErrorView.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import SwiftUI

struct ErrorView: View {
    var message: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "x.square")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text(message)
                .font(.callout)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ErrorView(message: "Lorem ipsum dolor sit amet")
}
