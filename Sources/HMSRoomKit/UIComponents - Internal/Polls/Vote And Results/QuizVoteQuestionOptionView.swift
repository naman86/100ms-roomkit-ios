//
//  QuizVoteQuestionOptionView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct QuizVoteQuestionOptionView: View {
    @ObservedObject var model: PollVoteQuestionOptionViewModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var body: some View {
        HStack {
            if model.isCorrect == true {
                Image(systemName: model.imageName).foregroundColor(HMSUIColorTheme().onPrimaryHigh)
            }
            Text(model.text).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body2Regular14)
            
            if model.selected {
                Spacer()
                Text(currentTheme.localized.yourAnswerTitle).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body2Regular14)
            }
        }
    }
}
