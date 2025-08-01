//
//  PollOptionView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct PollOptionView: View {
    @ObservedObject var model: QuestionOptionCreateModel
    @EnvironmentObject var currentTheme: HMSUITheme

    var body: some View {
        HStack(spacing: 0) {
            if model.showAnswerSelection {
                Button {
                    model.select()
                } label: {
                    Image(systemName: model.imageName).foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                }.frame(width: 44, height: 44)
                Spacer(minLength: 5)
            }
            
            PollTextField(placeholder: "\(currentTheme.localized.optionTitle) \(model.index)", text: $model.text, valid: model.valid)
        }
    }
}
