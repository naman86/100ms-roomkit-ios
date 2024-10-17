//
//  HMSEndCallView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 31/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSEndCallView: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        let isBeingStreamed = roomModel.isBeingStreamed
        let userCanStartStopHLSStream = roomModel.userCanStartStopHLSStream
        
        VStack(alignment: .leading, spacing: 24) {
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(assetName: "stop-stream-icon")
                        .frame(width: 24, height: 24)
                        .foreground(.errorDefault)
                    
                    Text(currentTheme.localized.endSession)
                        .font(.heading6Semibold20)
                        .foreground(.errorDefault)
                    
                    Spacer()
                    
                    Image(assetName: "xmark")
                        .foreground(.onSurfaceHigh)
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                Text(isBeingStreamed ? currentTheme.localized.endSessionMessageStreamPresented : currentTheme.localized.endSessionMessageStreamNotPresented)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
            }
            
            Text(currentTheme.localized.endSession)
                .font(.heading6Semibold20)
                .foreground(.errorBrighter)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.errorDefault, cornerRadius: 8)
                .onTapGesture {
                    Task {
                        if isBeingStreamed && userCanStartStopHLSStream  {
                            try await roomModel.stopStreaming()
                        }
                        try await roomModel.endSession()
                    }
                }
        }
        .padding(24)
        .background(.surfaceDim, cornerRadius: 0)
    }
}

struct HMSEndCallView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSEndCallView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
