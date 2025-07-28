//
//  HMSHLSQualityPickerView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 12/11/23.
//

import SwiftUI
import HMSHLSPlayerSDK

extension EnvironmentValues {
    var hlsPlaybackQuality: Binding<HMSHLSQualityPickerView.Quality> {
        get { self[HMSHLSQualityPickerView.Quality.Key.self] }
        set { self[HMSHLSQualityPickerView.Quality.Key.self] = newValue }
    }
}

struct HMSHLSQualityPickerView: View {
    
    enum Quality: String {
        case Auto, High, Medium, Low
        
        struct Key: EnvironmentKey {
            static let defaultValue: Binding<Quality> = .constant(.Auto)
        }
    }
    
    @Environment(\.hlsPlaybackQuality) var hlsPlaybackQuality
    @EnvironmentObject var currentTheme: HMSUITheme
    @Environment(\.dismiss) var dismiss
    
    let player: HMSHLSPlayer

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HMSOptionsHeaderView(title: currentTheme.localized.qualityTitle) {
                dismiss()
            } onBack: {}
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    Text(currentTheme.localized.qualityAutoTitle)
                        .foreground(.onSurfaceHigh)
                        .font(.subtitle2Semibold14)
                    
                    Spacer()
                    
                    if hlsPlaybackQuality.wrappedValue == .Auto {
                        Image(assetName: "checkmark")
                            .foreground(.onSurfaceHigh)
                    }
                }
                .padding(16)
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    player._nativePlayer.currentItem?.preferredPeakBitRate = 0
                    hlsPlaybackQuality.wrappedValue = .Auto
                    dismiss()
                }
                
                HStack {
                    Text(currentTheme.localized.qualityHighTitle)
                        .foreground(.onSurfaceHigh)
                        .font(.subtitle2Semibold14)
                        
                    Spacer()
                    
                    if hlsPlaybackQuality.wrappedValue == .High {
                        Image(assetName: "checkmark")
                            .foreground(.onSurfaceHigh)
                    }
                }
                .padding(16)
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    player._nativePlayer.currentItem?.preferredPeakBitRate = 1500 * 1000
                    hlsPlaybackQuality.wrappedValue = .High
                    dismiss()
                }
                
                HStack {
                    Text(currentTheme.localized.qualityMediumTitle)
                        .foreground(.onSurfaceHigh)
                        .font(.subtitle2Semibold14)
                        
                    Spacer()
                    
                    if hlsPlaybackQuality.wrappedValue == .Medium {
                        Image(assetName: "checkmark")
                            .foreground(.onSurfaceHigh)
                    }
                }
                .padding(16)
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    player._nativePlayer.currentItem?.preferredPeakBitRate = 850 * 1000
                    hlsPlaybackQuality.wrappedValue = .Medium
                    dismiss()
                }
                
                HStack {
                    Text(currentTheme.localized.qualityLowTitle)
                        .foreground(.onSurfaceHigh)
                        .font(.subtitle2Semibold14)
                        
                    Spacer()
                    
                    if hlsPlaybackQuality.wrappedValue == .Low {
                        Image(assetName: "checkmark")
                            .foreground(.onSurfaceHigh)
                    }
                }
                .padding(16)
                .background(.white.opacity(0.0001))
                .onTapGesture {
                    player._nativePlayer.currentItem?.preferredPeakBitRate = 450 * 1000
                    hlsPlaybackQuality.wrappedValue = .Low
                    dismiss()
                }
            }
        }
        .background(.surfaceDefault, cornerRadius: 8, ignoringEdges: .all)
    }
}

struct HMSHLSQualityPickerView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSQualityPickerView(player: HMSHLSPlayer())
            .environmentObject(HMSUITheme())
            .environment(\.colorScheme, .dark)
#endif
    }
}
