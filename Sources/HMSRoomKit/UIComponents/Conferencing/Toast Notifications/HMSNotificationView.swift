//
//  EndSessionAlertView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 11/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSNotificationView: View {
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    let notification: HMSRoomKitNotification
    let onDismiss: ()->Void
    let onAction: ()->Void
    
    var isErrorType: Bool {
        if case .error(_, _, _) = notification.type {
            return true
        }
        else {
            return false
        }
    }
    
    var isWarningType: Bool {
        if case .warning(_) = notification.type {
            return true
        }
        else {
            return false
        }
    }

    var body: some View {
        
        let onStageExperience = conferenceComponentParam.onStageExperience
        let bringToStageLabel = onStageExperience?.bringToStageLabel
        
        HStack(spacing: 0) {
            
            HStack(spacing: 12) {
                Group {
                    switch notification.type {
                    case .handRaised, .handRaisedGrouped:
                        Image(assetName: "hand-raise-icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foreground(.onSurfaceHigh)
                    case .declineRoleChange, .groupedDeclineRoleChange(_):
                        Image(assetName: "peer-xmark")
                            .foreground(.onSurfaceHigh)
                    case .error(icon: let icon, _, _), .info(icon: let icon):
                        if notification.id == "isReconnecting" {
                            HMSLoadingView {
                                Image(assetName: icon)
                                    .foreground(.onSurfaceHigh)
                            }
                        }
                        else {
                            Image(assetName: icon)
                                .foreground(.onSurfaceHigh)
                        }
                    case .screenShare:
                        Image(assetName: "screenshare-icon")
                            
                    case .poll:
                        Image(assetName: "poll-vote")
                    case .warning(icon: let icon):
                        Image(assetName: icon)
                            .foreground(.alertWarning)
                    case .closedCaptionStatus(icon: let icon):
                        if icon == "loading-record" {
                            HMSLoadingView {
                                Image(assetName: icon)
                                    .foreground(.onSurfaceHigh)
                            }
                        }
                        else {
                            Image(assetName: icon)
                                .foreground(.onSurfaceHigh)
                        }
                    }
                }
                .foreground(.onSurfaceHigh)
                
                Text(notification.title)
                    .lineLimit(2)
                    .font(.subtitle2Semibold14)
                    .foreground(.onSurfaceHigh)
            }
            
            Spacer(minLength: 16)
            
            HStack(spacing: 16) {
                
                Group {
                    switch notification.action {
                    case .none:
                        EmptyView()
                    case .bringOnStage:
                        Text(bringToStageLabel ?? "")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.body2Semibold14)
                            .foreground(.onSecondaryHigh)
                            .padding(8)
                            .background(.secondaryDefault, cornerRadius: 8)
                    case .viewBringOnStageParticipants:
                        Text(currentTheme.localized.view)
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.body2Semibold14)
                            .foreground(.onSecondaryHigh)
                            .padding(8)
                            .background(.secondaryDefault, cornerRadius: 8)
                    case .retry:
                        Text(currentTheme.localized.retry)
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.body2Semibold14)
                            .foreground(.onSecondaryHigh)
                            .padding(8)
                            .background(.secondaryDefault, cornerRadius: 8)
                    case .stopScreenShare:
                        HMSShareScreenButton {
                            Text(currentTheme.localized.stop)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.body2Semibold14)
                                .foreground(.errorBrighter)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(.errorDefault, cornerRadius: 8)
                        }
                    case .endCall:
                        Text(currentTheme.localized.endSession)
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.body2Semibold14)
                            .foreground(.errorBrighter)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(.errorDefault, cornerRadius: 8)
                    case .vote(let type):
                        Text(type == .poll ? currentTheme.localized.vote : currentTheme.localized.answer)
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.body2Semibold14)
                        .foreground(.onSecondaryHigh)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(.secondaryDefault, cornerRadius: 8)
                    }
                }
                .onTapGesture() {
                    onAction()
                }
                
                if notification.isDismissible {
                    Image(assetName: "xmark")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .frame(width: 24, height: 24)
                        .foreground(.onSurfaceHigh)
                        .onTapGesture {
                            onDismiss()
                        }
                }
            }
        }
        .padding(.leading, (isWarningType || isErrorType) ? 8 : 16)
        .padding(.trailing, 8)
        .padding(.vertical, 8)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .background(.surfaceDefault, cornerRadius: 8)
        .padding(.leading, (isWarningType || isErrorType) ? 8 : 0)
        .background(isWarningType ? .alertWarning : .errorDefault, cornerRadius: 8)
    }
}

struct HMSNotificationView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        VStack {
            HMSNotificationView(notification: .init(id: "id1", type: .error(icon: "record-on", retry: true, isTerminal: false), actor: "Pawan", isDismissible: true, title: "Recording failed to start"), onDismiss: {}, onAction: {})
            
            HMSNotificationView(notification: .init(id: "id2", type: .handRaised(canBringOnStage: false), actor: "Pawan", isDismissible: true, title: "Peer raised hands Peer raised hands Peer raised hands"), onDismiss: {}, onAction: {})
            
            HMSNotificationView(notification: .init(id: "id3", type: .error(icon: "warning-icon", retry: false, isTerminal: true), actor: "Pawan", isDismissible: false, title: "Recording failed to start"), onDismiss: {}, onAction: {})
        }
        .environmentObject(HMSUITheme())
        .environmentObject(HMSRoomInfoModel())
#endif
    }
}
