//
//  PollVoteQuestionOptionView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct PollVoteQuestionOptionView: View {
    @ObservedObject var model: PollVoteQuestionOptionViewModel
    @EnvironmentObject var currentTheme: HMSUITheme

    var body: some View {
        Button {
            model.select()
        } label: {
            HStack(spacing: 18) {
                if model.canVote || !model.canViewResponses {
                    Image(systemName: model.imageName).foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                }
                VStack {
                    if !model.canVote && model.canViewResponses {
                        HStack {
                            Text(model.text).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body2Regular14)
                            Spacer()
                            let voteTitle = model.voteCount == 1 ? currentTheme.localized.vote : currentTheme.localized.votes
                            Text("\(model.voteCount) \(voteTitle)").foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().body2Regular14)
                        }
                        ProgressView(value: model.progress).progressViewStyle(.linear)
                    } else {
                        Text(model.text).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body2Regular14)
                    }
                }
            }
        }.allowsHitTesting(model.canVote)
    }
}

