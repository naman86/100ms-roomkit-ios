//
//  HMSRoomInfoModel.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 20/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

class HMSRoomInfoModel: ObservableObject {
    
    // Color theme
    @Published var theme = HMSUITheme()
    
    // Preview screen
    enum PreviewType {
        case none, `default`
    }
    
    // .none means no preview screen
    @Published var previewType: PreviewType = .none
    @Published var defaultPreviewScreen: HMSRoomLayout.LayoutData.Screens.Preview.DefaultPreviewScreen?
    
    // Conferencing screen
    enum ConferencingType {
        case `default`, liveStreaming
    }
    
    // conferencing screen will always be there
    @Published var conferencingType: ConferencingType = .default
    @Published var defaultConferencingScreen: HMSRoomLayout.LayoutData.Screens.Conferencing.DefaultConferencingScreen?
    @Published var liveStreamingConferencingScreen: HMSRoomLayout.LayoutData.Screens.Conferencing.DefaultConferencingScreen?
    
    @Published var onStageRole = ""
    @Published var offStageRoles = [String]()
    @Published var bringToStageLabel = ""
    @Published var removeFromStageLabel = ""
    @Published var isBroadcaster: Bool = false
    
    @Published var isNoiseCancellationOnByDefault: Bool = false
    @Published var defaultVirtualBackgroundUrl: URL? = nil
    
    @Published var defaultLeaveScreen: HMSRoomLayout.LayoutData.Screens.Leave.DefaultLeaveScreen?
    
    init() {
        bringToStageLabel = theme.localized.bringOnStage
        removeFromStageLabel = theme.localized.removeFromStage
    }
    
    var roomLayout: HMSRoomLayout? {
        didSet {
            update()
        }
    }
    
    func update(role: String? = nil) {
        guard let roomLayout = roomLayout else { return }
        
        var layoutData: HMSRoomLayout.LayoutData?
        if let role = role, !role.isEmpty {
            layoutData = roomLayout.data?.first(where: { $0.role == role })
        }
        
        guard let layoutData = layoutData ?? roomLayout.data?.first else { return }
        
        // Update theme
        if let layoutTheme = layoutData.themes.first(where: {$0.default}) {
            // Load new color theme
            if let palette = layoutTheme.palette {
#if !Preview
                theme.colorTheme = HMSUIColorTheme(colorPalette: palette)
#endif
            }
        }
        
        // Update logo
        var logoUrl: URL? = nil
        if let logoString = layoutData.logo?.url {
            logoUrl = URL(string: logoString)
        }
        theme.logoURL = logoUrl
        
        // Update on stage experience
        if let stageExp = layoutData.screens?.conferencing.default?.elements?.on_stage_exp {
            isBroadcaster = true
            onStageRole = stageExp.on_stage_role
            offStageRoles = stageExp.off_stage_roles
            bringToStageLabel = stageExp.bring_to_stage_label
            removeFromStageLabel = stageExp.remove_from_stage_label
        } else {
            isBroadcaster = false
            onStageRole = ""
            offStageRoles = []
            bringToStageLabel = ""
            removeFromStageLabel = ""
        }
        
        // Update preview screen
        if layoutData.screens?.preview?.skip_preview_screen == true {
            previewType = .none
        }
        else if let previewScreen = layoutData.screens?.preview?.default {
            previewType = .default
            defaultPreviewScreen = previewScreen
            
            isNoiseCancellationOnByDefault = previewScreen.elements?.noise_cancellation?.enabled_by_default ?? false
        }
        
        // Update conferencing screen
        if let conferencingScreen = layoutData.screens?.conferencing.default {
            conferencingType = .default
            
            defaultConferencingScreen = conferencingScreen
            
            isNoiseCancellationOnByDefault = conferencingScreen.elements?.noise_cancellation?.enabled_by_default ?? false
            
            if let defaultVBMedia = conferencingScreen.elements?.virtual_background?.background_media?.first(where: { $0.default }) {
                
                defaultVirtualBackgroundUrl = URL(string: defaultVBMedia.url)
            }
        }
        else if let conferencingScreen = layoutData.screens?.conferencing.hls_live_streaming {
            conferencingType = .liveStreaming
            liveStreamingConferencingScreen = conferencingScreen
            
            isNoiseCancellationOnByDefault = conferencingScreen.elements?.noise_cancellation?.enabled_by_default ?? false
            
            if let defaultVBMedia = conferencingScreen.elements?.virtual_background?.background_media?.first(where: { $0.default }) {
                
                defaultVirtualBackgroundUrl = URL(string: defaultVBMedia.url)
            }
        }
        
        defaultLeaveScreen = layoutData.screens?.leave?.default
    }
}
