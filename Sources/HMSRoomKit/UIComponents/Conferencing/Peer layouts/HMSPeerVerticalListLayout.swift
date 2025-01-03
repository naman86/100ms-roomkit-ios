//
//  HMSPeersVerticalListView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 19/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

public struct HMSPeerVerticalListLayout: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @Environment(\.controlsState) private var controlsState
    
    public init() {}
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    public var body: some View {
        
        let isInsetMode = roomModel.isLocalTileInset
        let visiblePeers = roomModel.visiblePeersInLayout(isUsingInset: isInsetMode)
        
        if verticalSizeClass == .regular {
            VStack {
                ForEach(visiblePeers, id: \.self) { peer in
                    HMSPeerTile(peerModel: peer)
                        .background(.backgroundDefault, cornerRadius: 0)
                }
            }
        }
        else {
            HStack {
                ForEach(visiblePeers, id: \.self) { peer in
                    HMSPeerTile(peerModel: peer)
                        .background(.backgroundDefault, cornerRadius: 0)
                }
            }
        }
    }
}

struct HMSPeerVerticalListLayout_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPeerVerticalListLayout()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
