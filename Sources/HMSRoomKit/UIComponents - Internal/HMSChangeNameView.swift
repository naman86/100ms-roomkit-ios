//
//  HMSChangeNameView.swift
//  HMSRoomKit
//
//  Created by Dmitry Fedoseyev on 11.08.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSChangeNameView: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var isValid: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HMSOptionsHeaderView(title: currentTheme.localized.changeName) {
                presentationMode.wrappedValue.dismiss()
            } onBack: {}
            VStack(spacing: 16) {
                TextField(currentTheme.localized.enterName, text: $name, prompt: Text(currentTheme.localized.enterName).foregroundColor(currentTheme.colorTheme.onSurfaceLow))
                    .font(.body1Regular16)
                    .foreground(.onSurfaceHigh)
                    .padding()
                    .frame(height: 48)
                    .background(.surfaceDefault, cornerRadius: 8)
                    .onChange(of: name) { newValue in
                        isValid = !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    }
                Text(currentTheme.localized.change)
                    .font(.body1Semibold16)
                    .foreground(isValid ? .onPrimaryHigh : .onPrimaryLow)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
                    .background(isValid ? .primaryDefault :  .primaryDisabled, cornerRadius: 8)
                    .onTapGesture {
                        guard isValid else { return }
                        let newName = name
                        Task {
                            try await roomModel.changeUserName(to: newName)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
            }.padding(.horizontal, 24)
        }
    }
}

struct HMSChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSChangeNameView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomModel.dummyRoom(3)).background(HMSUITheme().colorTheme.surfaceDim)
#endif
    }
}
