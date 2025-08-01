//
//  HMSParticipantNameLabel.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSParticipantNameLabel: View {
    
    @ObservedObject var peerModel: HMSPeerModel
    @EnvironmentObject var currentTheme: HMSUITheme

    var body: some View {
        let name = peerModel.isLocal ? peerModel.name + " (\(currentTheme.localized.you))" : peerModel.name
        HMSParticipantNameLabelView(name: name, wifiStrength: peerModel.displayQuality, isSIP: peerModel.type == .sip)
    }
}

struct HMSParticipantNameLabel_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSParticipantNameLabel(peerModel: HMSPeerModel())
            .environmentObject(HMSUITheme())
#endif
    }
}
