//
//  HMSCancelButton.swift
//  HMSSDK
//
//  Created by Dmitry Fedoseyev on 21.07.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSCancelButton: View {
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var body: some View {
        Text(currentTheme.localized.cancel)
            .foreground(.errorBrighter)
            .font(.buttonSemibold16)
            .frame(width: 103, height: 48)
            .background(.errorDefault, cornerRadius: 8)
    }
}
