//
//  HMSPreivewParticipantLabel.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSPreviewParticipantsLabelView: View {
    @EnvironmentObject var currentTheme: HMSUITheme

    let peerCount: Int
    
    var body: some View {
        
        let peerCount = peerCount
        var remotePeerCount: Int {
            peerCount
        }
        
        Group {
            HStack {
//                Image(assetName: "people-icon")
//                    .renderingMode(.template)
                
                
                if remotePeerCount == 0 {
                    Text(currentTheme.localized.oneJoiningTitle)
                        .font(.body2Semibold14)
                }
                else {
                    let otherTitle = remotePeerCount > 1 ? currentTheme.localized.otherSingularTitle : currentTheme.localized.otherPluralTitle
                    Text("\(remotePeerCount) \(otherTitle) \(currentTheme.localized.inSessionTitle)")
                        .font(.body2Semibold14)
                }
                
                
//                else if peerCount == 1 {
//                    let nameString = peerNames.first ?? ""
//                    combinedTextView(nameString: nameString, staticString: "has joined")
//                }
//                else {
//                    let nameString = "\(peerNames.first ?? ""), \(peerNames[1])"
//                    
//                    if peerCount == 2 {
//                        combinedTextView(nameString: nameString, staticString: "have joined")
//                    }
//                    else if peerCount == 3 {
//                        combinedTextView(nameString: nameString, staticString: "and +1 other")
//                    }
//                    else if peerCount > 3 {
//                        combinedTextView(nameString: nameString, staticString: "and +\(peerCount - 2) others")
//                    }
//                }
            }
        }
        .foreground(.onSurfaceHigh)
        .frame(maxWidth: 269) // 269 is from figma design
        .fixedSize(horizontal: true, vertical: false)
        .padding(10)
        .padding(.horizontal, 5)
        .background(.surfaceDefault, cornerRadius: 20)
    }
    
    func combinedTextView(nameString: String, staticString: String) -> some View {
        HStack {
            Text(nameString)
                .truncationMode(.tail)
                .lineLimit(1)
            Text(staticString)
        }
    }
}

struct HMSPreviewParticipantsLabelView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HMSPreviewParticipantsLabelView(peerCount: 1)
                .environmentObject(HMSUITheme())
            
//            HMSPreviewParticipantsLabelView(peerNames: ["Marvel Pawan Kumar Dixit"])
//                .environmentObject(HMSUITheme())
//            
//            HMSPreviewParticipantsLabelView(peerNames: ["Dmitry", "Pawan Kumar Dixit"])
//                .environmentObject(HMSUITheme())
//            
//            HMSPreviewParticipantsLabelView(peerNames: ["Dmitry", "Pawan Kumar Dixit", "Yogesh"])
//                .environmentObject(HMSUITheme())
//            
//            HMSPreviewParticipantsLabelView(peerNames: ["Dmitry", "Pawan Kumar Dixit", "Yogesh", "Saikat"])
//                .environmentObject(HMSUITheme())
//            
//            HMSPreviewParticipantsLabelView(peerNames: ["Dmitry", "Pawan Kumar Dixit sssss ssss  sss  ss", "Yogesh", "Saikat", "pratim"])
//                .environmentObject(HMSUITheme())
        }
    }
}
