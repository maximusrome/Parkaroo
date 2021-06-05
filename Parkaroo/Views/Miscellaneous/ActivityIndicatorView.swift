//
//  ActivityIndicatorView.swift
//  Parkaroo
//
//  Created by Bernie Cartin on 5/22/21.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var body: some View {
        ZStack {
            Color(white: 0)
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(ShadowProgressViewStyle())
                .colorScheme(.dark)
        }
    }
}
struct ShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .scaleEffect(1.5)
    }
}
struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
