//
//  HMSSwitchLayoutButton.swift
//  HMSRoomKit
//
//  Created by Naman Singhal on 16/10/24.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSSwitchLayoutButton: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        if roomModel.localVideoTrackModel != nil {
            
            HMSSwitchLayoutButtonView(isEnabled: true, isInsetMode: roomModel.isLocalTileInset)
                .onTapGesture {
#if !Preview
                    roomModel.toggleLayout()
#endif
                }
        }
    }
}

struct HMSSwitchLayoutButton_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSSwitchLayoutButton()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(4))
#endif
    }
}
