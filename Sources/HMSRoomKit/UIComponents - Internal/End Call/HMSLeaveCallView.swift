//
//  HMSLeaveCallView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 31/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSLeaveCallView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        let isBeingStreamed = roomModel.isBeingStreamed
        let userCanStartStopHLSStream = roomModel.userCanStartStopHLSStream
        
        VStack(alignment: .leading, spacing: 24) {
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(assetName: "warning-icon")
                        .frame(width: 24, height: 24)
                        .foreground(.errorDefault)
                    
                    Text(currentTheme.localized.leaveSession)
                        .font(.heading6Semibold20)
                        .foreground(.errorDefault)
                    
                    Spacer()
                    
                    Image(assetName: "xmark")
                        .foreground(.onSurfaceHigh)
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                Text(currentTheme.localized.leaveSessionMessage)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
            }
            
            Text(currentTheme.localized.leaveSession)
                .font(.heading6Semibold20)
                .foreground(.errorBrighter)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.errorDefault, cornerRadius: 8)
                .onTapGesture {
                    Task {
                        if isBeingStreamed && userCanStartStopHLSStream {
                            let broadcastingPeers = roomModel.peerModels.filter{$0.canStartStopHLSStream}
                            if broadcastingPeers.count < 2 {
                                try await roomModel.stopStreaming()
                            }
                        }
                        try await roomModel.leaveSession()
                    }
                }
        }
        .padding(24)
        .background(.surfaceDim, cornerRadius: 0)
    }
}

struct HMSLeaveCallView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSLeaveCallView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
