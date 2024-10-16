//
//  HMSSwitchLayoutButtonView.swift
//  HMSRoomKit
//
//  Created by Naman Singhal on 16/10/24.
//

import SwiftUI

struct HMSSwitchLayoutButtonView: View {
    
    let isEnabled: Bool
    let isInsetMode: Bool
    
    var body: some View {
        Image(assetName: isInsetMode ? "switch-to-grid" : "switch-to-inset")
            .foreground(isEnabled ? .onSurfaceHigh : .onSurfaceLow)
            .frame(width: 40, height: 40)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1.0)
                    .foreground(.borderBright)
            }
            
    }
}

struct HMSSwitchLayoutButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HMSSwitchLayoutButtonView(isEnabled: true, isInsetMode: true)
            .environmentObject(HMSUITheme())
    }
}
