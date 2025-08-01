//
//  HMSSessionDescriptionView.swift
//  
//
//  Created by Dmitry Fedoseyev on 12.02.2024.
//

import SwiftUI
import HMSRoomModels

struct HMSConferenceDescriptionView: View {
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @State private var streamStartedText: String = ""
    var isExpanded: Bool
    
    let descriptionTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HMSCompanyLogoView()
                VStack(alignment: .leading, spacing: 4) {
                    if let headerText = conferenceComponentParam.header?.title {
                        Text(headerText)
                            .font(.subtitle2Semibold14)
                            .foreground(.onSecondaryHigh)
                    }
                    HStack {
                        Text("\(roomModel.viewerCountDisplayString) \(currentTheme.localized.watchingTitle)")
                            .lineLimit(1)
                            .font(.captionRegular12)
                            .foreground(.onSurfaceMedium)
                            .layoutPriority(2)
                        if !streamStartedText.isEmpty {
                            Text("•")
                                .font(.body2Regular14)
                                .foreground(.onSurfaceMedium)
                            Text("\(currentTheme.localized.startedTitle) \(streamStartedText) \(currentTheme.localized.agoTitle)")
                                .lineLimit(1)
                                .font(.captionRegular12)
                                .foreground(.onSurfaceMedium)
                                .layoutPriority(1)
                        }
                        if !isExpanded && conferenceComponentParam.header?.description != nil {
                            Text(currentTheme.localized.moreWithDotsTitle)
                                .lineLimit(1)
                                .font(.captionSemibold12)
                                .foreground(.onSurfaceHigh)
                                .layoutPriority(3)
                            
                        }
                        else if roomModel.recordingState == .recording {
                            Text("•")
                                .font(.body2Regular14)
                                .foreground(.onSurfaceMedium)
                            Text(currentTheme.localized.recordingTitle)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.captionRegular12)
                                .foreground(.onSurfaceMedium)
                        }
                        Spacer()
                    }
                }
            }.padding(16)
            if isExpanded, let descriptionText = conferenceComponentParam.header?.description {
                ScrollView {
                    VStack {
                        Text(descriptionText)
                            .font(.body2Regular14)
                            .foreground(.onSurfaceMedium)
                            .padding(.horizontal, 16)
                    }
                }
            }
            if !isExpanded {
                HMSDivider(color: currentTheme.colorTheme.borderBright)
            }
        }
        .onReceive(descriptionTimer) { time in
            refreshStreamStartedText()
        }
        .onAppear() {
            refreshStreamStartedText()
        }
    }
    
    private func refreshStreamStartedText() {
        if let variant = roomModel.hlsVariants.first,
           let startedAt = variant.startedAt {
            streamStartedText = startedAt.minutesSinceNow
        }
    }
}
