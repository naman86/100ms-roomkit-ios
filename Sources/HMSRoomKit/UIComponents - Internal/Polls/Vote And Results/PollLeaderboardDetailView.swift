//
//  PollLeaderboardDetailView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 20.12.2023.
//

import SwiftUI

struct PollLeaderboardDetailView: View {
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
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentTheme.localized.leaderboardTitle).foregroundColor(HMSUIColorTheme().onSurfaceHigh).font(HMSUIFontTheme().subtitle2Semibold14)
                            Text(currentTheme.localized.castAnswerMessage).foregroundColor(HMSUIColorTheme().onSurfaceMedium).font(HMSUIFontTheme().captionRegular)
                        }
                        Spacer()
                    }
                    
                    PollLeaderboardView(model: model)
                }
            }
        }
        .padding(.horizontal, 24)
        .background(HMSUIColorTheme().surfaceDim)
        .navigationBarHidden(true)
        .onAppear {
            model.fetchLeaderboard()
        }
        
    }
}
