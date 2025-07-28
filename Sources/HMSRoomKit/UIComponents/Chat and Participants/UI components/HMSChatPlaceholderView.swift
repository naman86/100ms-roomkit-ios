//
//  HMSChatPlaceholderView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSChatPlaceholderView: View {
    @EnvironmentObject var currentTheme: HMSUITheme

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(assetName: "chat-placeholder")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .minimumScaleFactor(0.5)
            Text(currentTheme.localized.startConversationTitle)
                .font(.heading6Semibold20)
                .foreground(.onSurfaceHigh)
            Text(currentTheme.localized.noMessageErrorTitle)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .font(.body2Regular14)
                .foreground(.onSurfaceMedium)
        }
    }
}

struct HMSChatPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        HMSChatPlaceholderView()
            .environmentObject(HMSUITheme())
    }
}
