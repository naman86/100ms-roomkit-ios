//
//  HMSMessageOptionsView.swift
//  HMSRoomKit
//
//  Created by Dmitry Fedoseyev on 27.07.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels
import HMSSDK

struct HMSMessageOptionsView: View {
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var roomModel: HMSRoomModel
    let messageModel: HMSMessage
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var recipient: HMSRecipient?
    
    var body: some View {
        
        let isPrivateChatScopeAvailable = conferenceParams.chat?.chatScopes.contains(.private) ?? false
        
        let canPinMessages =  conferenceParams.chat?.allowsPinningMessages ?? false
        let canBlockPeers =  conferenceParams.chat?.controls?.canBlockUser ?? false
        let canHideMessages =  conferenceParams.chat?.controls?.canHideMessage ?? false
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Text(currentTheme.localized.messageOptionsTitle)
                    .foreground(.onSurfaceHigh)
                    .font(.subtitle2Semibold16)
                
                Spacer()
                
                HMSXMarkView()
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding(.horizontal, 24)
            
            HMSDivider(color: currentTheme.colorTheme.borderBright)
            
            if isPrivateChatScopeAvailable, let sender = messageModel.sender, sender != roomModel.localPeerModel?.peer {
                
                HMSPeerLoaderView(peerId: sender.peerID) { peer in
                    HStack {
                        Image(assetName: "person-plus")
                            .frame(width: 20, height: 20)
                        Text(currentTheme.localized.messagePrivatelyTitle)
                            .font(.subtitle2Semibold14)
                        
                        Spacer()
                    }
                    .foreground(.onSurfaceHigh)
                    .padding(16)
                    .background(.white.opacity(0.0001))
                    .onTapGesture {
                        recipient = .peer(peer)
                        dismiss()
                    }
                }
            }
            
            if canPinMessages {
                HStack {
                    if roomModel.pinnedMessages.contains(where: {$0.id == messageModel.messageID}) {
                        Image(assetName: "unpin")
                            .frame(width: 20, height: 20)
                        Text(currentTheme.localized.unpinTitle)
                            .font(.subtitle2Semibold14)
                    }
                    else {
                        Image(assetName: "pin")
                            .frame(width: 20, height: 20)
                        Text(currentTheme.localized.pinTitle)
                            .font(.subtitle2Semibold14)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    if roomModel.pinnedMessages.contains(where: {$0.id == messageModel.messageID}) {
                        
                        roomModel.pinnedMessages.removeAll{$0.id == messageModel.messageID}
                    }
                    else {
                        roomModel.pinnedMessages.append(.init(text: "\(messageModel.sender?.name.appending(": ") ?? "")\(messageModel.message)", id: messageModel.messageID, pinnedBy: roomModel.userName))
                    }
                    dismiss()
                }
            }

            HStack {
                Image(assetName: "copy").frame(width: 20, height: 20)
                Text(currentTheme.localized.copyTextTitle).font(.subtitle2Semibold14)
                
                Spacer()
            }
            .padding(16)
            .background(.white.opacity(0.0001))
            .onTapGesture {
                UIPasteboard.general.string = messageModel.message
                dismiss()
            }
            
            if canHideMessages {
                HStack {
                    Image(assetName: "eye-crossed")
                        .frame(width: 20, height: 20)
                    Text(currentTheme.localized.hideMessagesTitle)
                        .font(.subtitle2Semibold14)
                    
                    Spacer()
                }
                .foreground(.onSurfaceHigh)
                .padding(16)
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    roomModel.chatMessageBlacklist.append(messageModel.messageID)
                }
            }
            
            if canBlockPeers, let sender = messageModel.sender, sender != roomModel.localPeerModel?.peer {
                HStack {
                    Image(assetName: "circle-minus")
                        .frame(width: 20, height: 20)
                    Text(currentTheme.localized.chatBlockTitle)
                        .font(.subtitle2Semibold14)
                    
                    Spacer()
                }
                .foreground(.errorDefault)
                .padding(16)
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    if let sender = messageModel.sender, let customerUserID = sender.customerUserID {
                        roomModel.chatPeerBlacklist.append(customerUserID)
                    }
                    dismiss()
                }
            }
            
            if roomModel.localPeerModel?.role?.permissions.removeOthers ?? false, let sender = messageModel.sender, sender.peerID != roomModel.localPeerModel?.id {
                
                HMSPeerLoaderView(peerId: sender.peerID) { peer in
                    HStack {
                        Image(assetName: "peer-remove")
                        Text(currentTheme.localized.removeParticipant).font(.subtitle2Semibold14)
                        Spacer(minLength: 0)
                    }
                    .foreground(.errorDefault)
                    .padding(16)
                    .background(.white.opacity(0.0001))
                    .onTapGesture {
                        Task {
                            try await roomModel.remove(peer: peer)
                        }
                        dismiss()
                    }
                }
            }
        }
        .foreground(.onSurfaceHigh)
        .background(.surfaceDefault, cornerRadius: 8, border: .borderBright, ignoringEdges: .all)
    }
}

struct HMSMessageOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSMessageOptionsView(messageModel: HMSMessage(message: "hey"), recipient: .constant(.everyone))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
