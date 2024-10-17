//
//  HMSPreviewRoleBottomOverlay.swift
//  HMSSDK
//
//  Created by Dmitry Fedoseyev on 23/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import Combine

import HMSSDK
import HMSRoomModels

struct HMSPreviewRoleBottomOverlay: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(currentTheme.localized.joinStageMessage)
                    .font(.heading6Semibold20)
                    .foreground(.onSurfaceHigh)
                Text(currentTheme.localized.setupAudioVideoMessage)
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
            }
            HStack {
                
                if roomModel.previewAudioTrack != nil {
                    HMSMicToggle()
                }
                
                if roomModel.previewVideoTrack != nil {
                    HMSCameraToggle()
                    HMSSwitchCameraButton()
                }
                
                Spacer()
                HMSAirplayButton {
                    HMSSpeakerButtonView()
                }
            }

            VStack(spacing: 16) {
                Text(currentTheme.localized.joinNow)
                    .font(.body1Semibold16)
                    .foreground(.onPrimaryHigh)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
                    .background(.primaryDefault, cornerRadius: 8)
                    .onTapGesture {
                        Task {
                            try await roomModel.setUserStatus(.none)
                            try await roomModel.acceptChangeRoleRequest()
                        }
                    }
                Text(currentTheme.localized.decline)
                    .font(.body1Semibold16)
                    .foreground(.onSurfaceHigh)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
                    .background(.secondaryDefault, cornerRadius: 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(currentTheme.colorTheme.secondaryDefault, lineWidth: 1)
                    )
                    .onTapGesture {
                        Task {
                            try await roomModel.setUserStatus(.none)
                            try await roomModel.declineChangeRoleRequestAndNotify()
                        }
                    }
            }
        }
        .padding(16)
        .background(.surfaceDim, cornerRadius: 16, corners: [.topLeft, .topRight], ignoringEdges: .all)
    }
}

struct HHMSPreviewRoleBottomOverlay_Previews: PreviewProvider {
    
    static var previews: some View {
#if Preview
        HMSPreviewRoleBottomOverlay()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
