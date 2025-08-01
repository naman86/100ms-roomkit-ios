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

struct HMSPeerOptionsViewContext {
    enum Action: Equatable, Hashable {
        case videoMuteToggle(Bool)
        case audioMuteToggle(Bool)
        case pin(HMSPeerModel)
        case spotlight(HMSPeerModel)
        case changeName
        case volume
        case removeParticipant
        case minimizeTile
        case bringOnStage(String)
        case removeFromStage(String)
        case lowerHand
        case none
        case switchRole
    }
    
    @Binding var isPresented: Bool
    @Binding var action: Action
    var volume: Binding<Double>?
    var name: String
    var role: String
    
    var actions: [HMSPeerOptionsViewContext.Action]
}

struct HMSPeerOptionsButtonView<Content: View>: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    @Environment(\.menuContext) var menuContext
    
    @AppStorage("isInsetMinimized") var isInsetMinimized: Bool = false
    
    @State private var isPresented = false
    @State private var menuAction: HMSPeerOptionsViewContext.Action = .none
    let label: () -> Content
    let dismiss:(() -> Void)?
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @ObservedObject var peerModel: HMSPeerModel
    
    internal init(peerModel: HMSPeerModel, dismiss: (() -> Void)? = nil, @ViewBuilder label: @escaping (() -> Content)) {
        self.peerModel = peerModel
        self.label = label
        self.dismiss = dismiss
    }
    
    var body: some View {
        if let context = peerModel.popoverContext(roomModel: roomModel, conferenceParams: conferenceComponentParam, isPresented: $isPresented, menuAction: $menuAction, currentTheme: currentTheme) {
            label()
                .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .local).onEnded({ _ in
                    isPresented.toggle()
                }))
                .opacity(context.actions.isEmpty ? 0 : 1)
                .sheet(isPresented: $isPresented, onDismiss: {
                    dismiss?()
                }) {
                    HMSSheet {
                        Group {
                            if verticalSizeClass == .regular {
                                HMSPeerOptionsView(context: context)
                            }
                            else {
                                ScrollView {
                                    HMSPeerOptionsView(context: context)
                                }
                            }
                        }
                        .environmentObject(roomModel)
                        .environmentObject(peerModel)
                    }
                    .edgesIgnoringSafeArea(.all)
                    .environmentObject(currentTheme)
                }
                .onChange(of: menuAction) { value in
                    switch value {
                    case .videoMuteToggle:
                        break
                    case .audioMuteToggle:
                        break
                    case .removeParticipant:
                        break
                    case .minimizeTile:
                        break
                    case .bringOnStage:
                        break
                    case .removeFromStage:
                        break
                    case .lowerHand:
                        Task {
                            try await roomModel.lowerHand(of: peerModel)
                        }
                        break
                    case .pin:
                        break
                    case .spotlight:
                        break
                    default:
                        break
                    }
                }
        }
    }
}

struct HMSOptionsHeaderView: View {
    
    var title: String
    var subtitle: String?
    var showsBackButton: Bool = false
    var showsDivider: Bool = false
    var onClose: (() -> Void)?
    var onBack: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                if showsBackButton {
                    Image(assetName: "back")
                        .foreground(.onSurfaceHigh)
                        .onTapGesture {
                            onBack?()
                        }
                    Spacer()
                        .frame(width:8)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subtitle1)
                        .foreground(.onSurfaceHigh)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.captionRegular12)
                            .foreground(.onSurfaceMedium)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer()
                Image(assetName: "close")
                    .foreground(.onSurfaceHigh)
                    .onTapGesture {
                        onClose?()
                    }
            }
            .padding(.horizontal, showsBackButton ? 16 : 24)
            .padding(.vertical, 16)
            if showsDivider {
                Divider()
                    .background(.borderBright, cornerRadius: 0)
            }
        }
    }
}

struct HMSPeerOptionsView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var peerModel: HMSPeerModel
    
    @AppStorage("isInsetMinimized") var isInsetMinimized: Bool = false
    
    var context: HMSPeerOptionsViewContext
    
    @State private var isChangeNameSheetPresented: Bool = false
    @State private var isChangeRoleSheetPresented: Bool = false
    
    var body: some View {
        
        let isSpotlightEnabled = conferenceComponentParam.tileLayout?.grid.canSpotlightParticipant ?? false
        let onStageExperience = conferenceComponentParam.onStageExperience
        let onStageRoleName = onStageExperience?.onStageRoleName ?? ""
        
        VStack(alignment: .leading, spacing: 0) {
            HMSOptionsHeaderView(title: peerModel.name + (peerModel.isLocal ? " (\(currentTheme.localized.you))" : ""), subtitle: peerModel.role?.name, onClose: {
                context.isPresented = false
            })
            VStack(alignment: .leading, spacing: 8) {
                ForEach(context.actions, id: \.self) { action in
                    switch action {
                    case .changeName:
                        HStack {
                            Image(assetName: "pencil")
                            Text(currentTheme.localized.changeName)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            isChangeNameSheetPresented = true
                        }
                    case .audioMuteToggle(_):
                        if let regularAudioTrackModel = peerModel.regularAudioTrackModel {
                            HMSPeerAudioMuteOptionView(regularAudioTrackModel: regularAudioTrackModel)
                                .background(.white.opacity(0.0001))
                                .onTapGesture {
                                    Task {
                                        try await peerModel.regularAudioTrackModel?.toggleMute()
                                    }
                                    context.isPresented = false
                                }
                        }
                    case .videoMuteToggle(_):
                        if let regularVideoTrackModel = peerModel.regularVideoTrackModel {
                            HMSPeerVideoMuteOptionView(regularVideoTrackModel: regularVideoTrackModel)
                                .background(.white.opacity(0.0001))
                                .onTapGesture {
                                    Task {
                                        try await peerModel.regularVideoTrackModel?.toggleMute()
                                    }
                                    context.isPresented = false
                                }
                        }
                    case .removeParticipant:
                        HStack {
                            Image(assetName: "peer-remove")
                            Text(currentTheme.localized.removeParticipant).font(.subtitle2Semibold14)
                            Spacer(minLength: 0)
                        }
                        .foreground(.errorDefault)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            Task {
                                try await roomModel.remove(peer: peerModel)
                            }
                            context.isPresented = false
                        }
                    case .switchRole:
                        HStack {
                            Image(assetName: "user-gear")
                            Text(currentTheme.localized.switchRole).font(.subtitle2Semibold14)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            isChangeRoleSheetPresented = true
                        }
                    case .minimizeTile:
                        HStack {
                            Image(assetName: "minimize-icon").padding(.horizontal, 3)
                            Text(currentTheme.localized.minimizeYourTile)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            isInsetMinimized = true
                            context.isPresented = false
                        }
                    case .bringOnStage(let label):
                        HStack {
                            Image(assetName: "stage")
                            Text(label)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            guard !onStageRoleName.isEmpty else { return }
                            let skipPreview = onStageExperience?.skipPreviewForRoleChange ?? false
                            Task {
                                try await roomModel.changeRole(of: peerModel, to: onStageRoleName, shouldAskForApproval: !skipPreview)
                                if skipPreview {
                                    try await roomModel.lowerHand(of: peerModel)
                                }
                            }
                            context.isPresented = false
                        }
                    case .removeFromStage(let label):
                        HStack {
                            Image(assetName: "stage")
                            Text(label)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            guard !peerModel.previousRole.isEmpty else {
                                return
                            }
                            Task {
                                try await roomModel.changeRole(of: peerModel, to: peerModel.previousRole, shouldAskForApproval: false)
                            }
                            context.isPresented = false
                        }
                    case .pin(let peer):
                        HStack {
                            Image(assetName: "pin")
                            Text(roomModel.pinnedPeers.contains(peer) ? currentTheme.localized.unpinTile : currentTheme.localized.pinTile)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.white.opacity(0.0001))
                        .onTapGesture {
                            if roomModel.pinnedPeers.contains(peer) {
                                roomModel.pinnedPeers.removeAll{$0 == peer}
                            }
                            else {
                                roomModel.pinnedPeers.append(peer)
                            }
                            context.isPresented = false
                        }
                    case .spotlight(let peer):
                        if isSpotlightEnabled {
                            HStack {
                                Image(assetName: "star")
                                Text(roomModel.spotlightedPeer == peer ? currentTheme.localized.spotlightTileRemove : currentTheme.localized.spotlightTileAdd)
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(.white.opacity(0.0001))
                            .onTapGesture {
                                roomModel.spotlightedPeer = roomModel.spotlightedPeer == peer ? nil : peerModel
                                context.isPresented = false
                            }
                        }
                    case .volume:
                        if let regularAudioTrackModel = peerModel.regularAudioTrackModel {
                            HMSPeerVolumeOptionView(regularAudioTrackModel: regularAudioTrackModel)
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .font(.subtitle2Semibold14)
        .foreground(.onSurfaceHigh)
        .sheet(isPresented: $isChangeNameSheetPresented) {
            HMSSheet {
                if verticalSizeClass == .regular {
                    HMSChangeNameView()
                }
                else {
                    ScrollView {
                        HMSChangeNameView()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $isChangeRoleSheetPresented) {
            if let role = peerModel.role {
                HMSSheet {
                    if verticalSizeClass == .regular {
                        HMSChangeRoleView(peerModel: peerModel, roleName: role.name)
                    }
                    else {
                        ScrollView {
                            HMSChangeRoleView(peerModel: peerModel, roleName: role.name)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
//            .background(.backgroundDim, cornerRadius: 8.0, ignoringEdges: .all)
    }
}


struct HMSPeerOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        let context = HMSPeerOptionsViewContext(isPresented: .constant(true), action: .constant(.minimizeTile), volume: .constant(1), name:"John", role:"Host", actions: [])
        HMSPeerOptionsView(context: context)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.localPeer)
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
