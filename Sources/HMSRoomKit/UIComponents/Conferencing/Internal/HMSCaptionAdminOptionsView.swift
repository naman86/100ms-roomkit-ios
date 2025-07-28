//
//  HMSCaptionAdminOptionsView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 5/14/24.
//

import SwiftUI
import HMSRoomModels
import Combine

struct HMSCaptionAdminOptionsView: View {
    
    @EnvironmentObject var roomKitModel: HMSRoomNotificationModel
    @EnvironmentObject var currentTheme: HMSUITheme

    @EnvironmentObject var roomModel: HMSRoomModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.captionsState) var captionsState
    
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HMSOptionsHeaderView(title: roomModel.isTranscriptionStarted ? currentTheme.localized.closedCaptionsCCTitle : currentTheme.localized.enableClosedCaptionsTitle, onClose: {
                dismiss()
            })
            .padding(.top, -16)
            VStack(alignment: .leading, spacing: 16) {
                
                if !roomModel.isTranscriptionStarted {
                    HStack(alignment: .top, spacing: 16) {
                        Text(currentTheme.localized.closedCaptionsEnabledTitle)
                            .foreground(.onPrimaryHigh)
                            .font(.buttonSemibold16)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.primaryDefault, cornerRadius: 8)
                    .onTapGesture {
                        Task {

                            let note = HMSRoomKitNotification(id: UUID().uuidString, type: .closedCaptionStatus(icon: "loading-record"), actor: "", isDismissible: false, title: currentTheme.localized.closedCaptionsEnablingTitle)
                            roomKitModel.addNotification(note)
                            
                            do {
                                cancellable = roomModel.$transcriptionStates.sink { transcriptionStates in
                                    
                                    guard let captionState = transcriptionStates.stateWith(mode: HMSTranscriptionMode.caption) else { return }
                                    if captionState.state == .started {
                                        roomKitModel.removeNotification(for: [note.id])
                                        cancellable = nil
                                    }
                                }
                                try await roomModel.startTranscription()
                                captionsState.wrappedValue = .visible
                            }
                            catch {
                                roomKitModel.removeNotification(for: [note.id])
                                roomKitModel.addNotification(HMSRoomKitNotification(id: UUID().uuidString, type: .error(icon: "warning-icon", retry: false, isTerminal: false), actor: "", isDismissible: true, title: currentTheme.localized.closedCaptionsEnableErrorTitle))
                                cancellable = nil
                            }

                            dismiss()
                            dismiss()
                        }
                    }
                }
                else {
                    HStack(alignment: .top, spacing: 16) {
                        Text(captionsState.wrappedValue == .visible ? "Hide for Me" : "Show for Me")
                            .foreground(.onSecondaryHigh)
                            .font(.buttonSemibold16)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.secondaryDefault, cornerRadius: 8)
                    .onTapGesture {
                        captionsState.wrappedValue = captionsState.wrappedValue == .visible ? .hidden : .visible
                        dismiss()
                    }
                    
                    HStack(alignment: .top, spacing: 16) {
                        Text(currentTheme.localized.closedCaptionsDisabledTitle)
                            .foreground(.errorBrighter)
                            .font(.buttonSemibold16)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.errorDefault, cornerRadius: 8)
                    .onTapGesture {
                        Task {
                            let note = HMSRoomKitNotification(id: UUID().uuidString, type: .closedCaptionStatus(icon: "loading-record"), actor: "", isDismissible: false, title: currentTheme.localized.closedCaptionsDisablingTitle)
                            roomKitModel.addNotification(note)
                            
                            do {
                                cancellable = roomModel.$transcriptionStates.sink { transcriptionStates in
                                    
                                    guard let captionState = transcriptionStates.stateWith(mode: HMSTranscriptionMode.caption) else { return }
                                    if captionState.state == .stopped {
                                        roomKitModel.removeNotification(for: [note.id])
                                        cancellable = nil
                                    }
                                }
                                try await roomModel.stopTranscription()
                            }
                            catch {
                                roomKitModel.removeNotification(for: [note.id])
                                cancellable = nil
                            }
                            
                            dismiss()
                            dismiss()
                        }
                    }
                }
                
                Text(!roomModel.isTranscriptionStarted ? currentTheme.localized.closedCaptionsEnableMessage : currentTheme.localized.closedCaptionsDisableMessage)
                    .foreground(.onSurfaceMedium)
                    .font(.body2Regular14)
                
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 24)
    }
}

struct HMSCaptionAdminOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSCaptionAdminOptionsView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environment(\.captionsState, .constant(.hidden))
#endif
    }
}
