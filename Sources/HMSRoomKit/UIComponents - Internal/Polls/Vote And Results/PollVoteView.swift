//
//  PollVoteView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 25.05.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

struct PollVoteView: View {
    internal init(model: PollVoteViewModel) {
        self.model = model
    }
    
    @ObservedObject var model: PollVoteViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var currentTheme: HMSUITheme

    var body: some View {
        VStack(alignment: .trailing) {
            Spacer(minLength: 24)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("", systemImage: "chevron.left").foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                }
                Text(model.poll.title).lineLimit(1).truncationMode(.tail).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().heading6Semibold20)
                PollStateBadgeView(pollState: model.poll.state, endDate: model.endDate)
                Spacer().frame(height: 16)
            }
            Spacer(minLength: 16)
            PollDivider()
            Spacer(minLength: 24)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if !model.startedByName.isEmpty {
                        Text("\(model.startedByName) \(currentTheme.localized.pollTitle) \(model.poll.category == .poll ? currentTheme.localized.pollStr : currentTheme.localized.quizStr)").foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().subtitle1)
                    }
                    if let summary = model.summary {
                        Text(currentTheme.localized.participationSummaryTitle).foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().subtitle2Semibold14)
                        PollSummaryView(model: summary).padding(.bottom, 8)
                        Text(currentTheme.localized.questionsTitle).foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().subtitle2Semibold14)
                    }
                    
                    if model.poll.category == .quiz, !model.questions.isEmpty, !model.voteComplete {
                        PollVoteQuestionCarouselView(questions: model.questions)
                    } else {
                        ForEach(model.questions) { question in
                            PollVoteQuestionView(model: question) {
                                question.vote()
                            }
                        }
                    }
                    
                    if model.canEndPoll && model.poll.state != .stopped {
                        HStack {
                            Spacer()
                            Button {
                                model.endPoll() {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                Text("\(currentTheme.localized.endTitle) \(model.poll.category == .poll ? currentTheme.localized.pollStr : currentTheme.localized.quizStr)")
                            }.buttonStyle(ActionButtonStyle(isWide: false))
                        }
                    } else if model.poll.state == .stopped && model.poll.category == .quiz {
                        NavigationLink() {
                            PollResultsView(model: model.leaderBoardModel)
                        } label: {
                            HStack {
                                Spacer()
                                Button {} label: {
                                    Text(currentTheme.localized.viewLeaderBoardTitle)
                                }.buttonStyle(ActionButtonStyle(isWide: false)).allowsHitTesting(false)
                            }
                        }
                    }
                }
            }.background(HMSUIColorTheme().surfaceDim)
        }
        .environmentObject(currentTheme)
        .padding(.horizontal, 24)
        .background(HMSUIColorTheme().surfaceDim)
        .onAppear {
            model.load(currentTheme: currentTheme)
        }
        .navigationBarHidden(true)
    }
}
