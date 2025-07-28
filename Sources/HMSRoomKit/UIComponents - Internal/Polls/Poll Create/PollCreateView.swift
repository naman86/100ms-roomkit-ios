//
//  PollCreateView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 18.05.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

struct PollCreateView: View {
    @ObservedObject var model: PollCreateModel
    @EnvironmentObject var currentTheme: HMSUITheme

    init(model: PollCreateModel) {
        self.model = model
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer(minLength: 24)
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("", systemImage: "chevron.left").foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                    }
                    Text("\(currentTheme.localized.pollStr)/\((currentTheme.localized.quizStr))").foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().heading6Semibold20)
                    Spacer().frame(height: 16)
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("", systemImage: "xmark").foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                    }
                    
                }.padding(.horizontal, 24)
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer().frame(height: 16)
                        if model.canCreatePolls {
                            Group {
                                Text(currentTheme.localized.selectTypeTitle).foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().captionRegular)
                                Spacer().frame(height: 16)
                                HStack(spacing: 16) {
                                    PollTypeButton(text: currentTheme.localized.pollStr, icon: "chart.bar.fill", selected: model.selectedCategory == .poll) {
                                        model.selectedCategory = .poll
                                    }
                                    PollTypeButton(text: currentTheme.localized.quizStr, icon: "questionmark.circle", selected: model.selectedCategory == .quiz) {
                                        model.selectedCategory = .quiz
                                    }
                                }
                                Spacer().frame(height: 16)
                            }
                            
                            Group {
                                Text("\(currentTheme.localized.nameThisTitle) \(model.selectedCategory == .poll ? currentTheme.localized.pollStr : currentTheme.localized.quizStr)").foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body2Regular14)
                                Spacer().frame(height: 8)
                                PollTextField(placeholder: "\(currentTheme.localized.my) \(model.selectedCategory == .poll ? currentTheme.localized.pollStr : currentTheme.localized.quizStr)", text: $model.pollTitle, valid: model.valid)
                                Spacer().frame(height: 24)
                            }
                            
                            Group {
                                SwitchView(text: currentTheme.localized.hideVoteCountTitle, isOn: $model.hideVotes)
                                Spacer().frame(height: 24)
                            }
                            
                            Group {
                                if !model.valid {
                                    Text(model.errorMessage).foregroundColor(HMSUIColorTheme().alertErrorDefault).font(HMSUIFontTheme().body2Regular14)
                                    Spacer().frame(height: 16)
                                }
                                
                                NavigationLink(destination: PollQuestionsCreateView(model: model.questionModel), isActive: $model.isShowingQuestionView) {
                                    EmptyView()
                                }
                                
                                Button("\(currentTheme.localized.createTitle) \(model.selectedCategory == .poll ? currentTheme.localized.pollStr : currentTheme.localized.quizStr)") {
                                    model.createPoll()
                                }.buttonStyle(ActionButtonStyle())
                                
                                Spacer(minLength: 24)
                            }
                        }
                        
                        if !model.currentPolls.isEmpty {
                            VStack(alignment: .leading, spacing: 24) {
                                Text(currentTheme.localized.previousTitle).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().heading6Semibold20)
                                ForEach(model.currentPolls) { pollListModel in
                                    NavigationLink() {
                                        if pollListModel.state == .created, let createModel = pollListModel.createModel {
                                            PollQuestionsCreateView(model: QuestionCreateViewModel(pollModel: createModel)) }
                                        else if let resultModel = pollListModel.resultModel {
                                            PollVoteView(model: resultModel)
                                        }
                                    } label: {
                                        PollListEntryView(model: pollListModel)
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 24)
                }
            }
            .background(HMSUIColorTheme().surfaceDim)
            .onAppear {
                model.refreshPolls()
            }
        }
    }
}
