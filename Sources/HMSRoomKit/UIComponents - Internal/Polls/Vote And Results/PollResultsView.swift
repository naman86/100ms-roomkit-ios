//
//  PollResultsView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 29.11.2023.
//

import SwiftUI
import HMSRoomModels

struct PollResultsView: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @ObservedObject var model: PollLeaderboardViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var currentTheme: HMSUITheme

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Spacer(minLength: 24)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("", systemImage: "chevron.left").foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                }
                Text(model.poll.title).lineLimit(1).truncationMode(.tail).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().heading6Semibold20)
                PollStateBadgeView(pollState: model.poll.state)
                Spacer().frame(height: 16)
            }
            Spacer(minLength: 16)
            PollDivider()
            Spacer(minLength: 24)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let summary = model.summary {
                        Text(currentTheme.localized.participationSummaryTitle).foregroundColor(HMSUIColorTheme().onSurfaceHigh).font(HMSUIFontTheme().subtitle2Semibold14)
                        PollSummaryView(model: summary).padding(.bottom, 8)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentTheme.localized.leaderboardTitle).foregroundColor(HMSUIColorTheme().onSurfaceHigh).font(HMSUIFontTheme().subtitle2Semibold14)
                            Text(currentTheme.localized.castAnswerMessage).foregroundColor(HMSUIColorTheme().onSurfaceMedium).font(HMSUIFontTheme().captionRegular)
                        }
                        Spacer()
                    }
                    
                    if !model.summaryEntries.isEmpty {
                        VStack(spacing: 0) {
                            PollLeaderboardView(model: model, isSummary: true)
                                .padding(EdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 16))
                            if model.showViewAll {
                                PollDivider()
                                HStack {
                                    Spacer()
                                    NavigationLink {
                                        PollLeaderboardDetailView(model: model)
                                    } label: {
                                        HStack {
                                            Text(currentTheme.localized.viewAllTitle).font(.body2Regular14).foreground(.onSurfaceHigh)
                                            Image(assetName: "back").foreground(.onSurfaceHigh)
                                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                        }
                                    }
                                }.padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                    .environmentObject(currentTheme)
                            }
                        }
                        .environmentObject(currentTheme)
                        .background(HMSUIColorTheme().surfaceDefault)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .environmentObject(currentTheme)
        .padding(.horizontal, 24)
        .background(HMSUIColorTheme().surfaceDim)
        .navigationBarHidden(true)
        .onAppear {
            model.fetchLeaderboardSummary(userID: roomModel.localPeerModel?.customerUserId ?? "")
        }
        
    }
}
