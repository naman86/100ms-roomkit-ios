//
//  HMSPeerOptionsView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 05/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSPeerAudioMuteOptionView: View {
    
    @ObservedObject var regularAudioTrackModel: HMSTrackModel
    @EnvironmentObject var currentTheme: HMSUITheme

    var body: some View {
        
        HStack {
            Image(assetName: "mic.slash")
                .resizable()
                .frame(width: 20, height: 20)
            Text(regularAudioTrackModel.isMute ? currentTheme.localized.requestUnmuteTitle : currentTheme.localized.muteAudioTitle)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
    }
}

struct HMSPeerAudioMuteOptionView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerAudioMuteOptionView(regularAudioTrackModel: HMSTrackModel())
#endif
    }
}
