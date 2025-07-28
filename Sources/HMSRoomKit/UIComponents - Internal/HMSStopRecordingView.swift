//
//  HMSStopRecordingView.swift
//  HMSSDK
//
//  Created by Dmitry Fedoseyev on 14.08.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSStopRecordingView: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var currentTheme: HMSUITheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(assetName: "warning-icon-large")
                Text(currentTheme.localized.stopRecordingTitle)
                    .font(.heading6Semibold20)
                    .foreground(.errorDefault)
                Spacer()
                Image(assetName: "close")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            Text(currentTheme.localized.stopRecordingMessage).fixedSize(horizontal: false, vertical: true).font(.body2Regular14).foreground(.onSurfaceMedium)
            Spacer().frame(height: 8)
            Text(currentTheme.localized.stop).font(.buttonSemibold16).foreground(.errorBrighter).frame(maxWidth: .infinity).padding(.vertical, 12).background(.errorDefault, cornerRadius: 8).onTapGesture {
                Task {
                    try await roomModel.stopRecording()
                }
                presentationMode.wrappedValue.dismiss()
            }
        }.padding(24)
        
    }
}

struct HMSStopRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        HMSStopRecordingView().environmentObject(HMSUITheme())
    }
}
