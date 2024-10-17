//
//  HMSStreamNotStartedView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 18/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSNoStreamView: View {
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    enum State {
        case streamEnded, streamYetToStart
    }
    
    let state: State
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 24) {
                Circle()
                    .foreground(.surfaceDefault)
                    .overlay {
                        Image(assetName: "stream-icon")
                            .resizable()
                            .foreground(.onSurfaceHigh)
                            .frame(width: 56, height: 56)
                    }
                    .frame(width: 80, height: 80)
                
                
                VStack(spacing: 8) {
                    switch state {
                    case .streamEnded:
                        Text(currentTheme.localized.streamEnded)
                            .font(.heading5Semibold24)
                            .foreground(.onSurfaceHigh)
                        
                        Text(currentTheme.localized.sessionEndedMessage)
                            .font(.body1Regular16)
                            .foreground(.onSurfaceMedium)
                    case .streamYetToStart:
                        Text(currentTheme.localized.streamYetToStart)
                            .font(.heading5Semibold24)
                            .foreground(.onSurfaceHigh)
                        
                        Text(currentTheme.localized.sesionYetToStartMessage)
                            .font(.body1Regular16)
                            .foreground(.onSurfaceMedium)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .background(.white.opacity(0.0001))
    }
}

struct HMSStreamNotStartedView_Previews: PreviewProvider {
    static var previews: some View {
        HMSNoStreamView(state: .streamYetToStart)
            .environmentObject(HMSUITheme())
    }
}
