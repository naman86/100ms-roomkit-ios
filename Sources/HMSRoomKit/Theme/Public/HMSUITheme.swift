//
//  ThemeCenter.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 12/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import Combine
import HMSSDK

public class HMSUITheme: ObservableObject {
    public var fontTheme: HMSUIFontTheme
    public var colorTheme: HMSUIColorTheme
    public var localized: HMSUIStrings
    public var logoURL: URL?
    
    public init(fontTheme: HMSUIFontTheme = HMSUIFontTheme(), colorTheme: HMSUIColorTheme = HMSUIColorTheme(), localized: HMSUIStrings = HMSUIStrings(), logoURL: URL? = nil) {
        self.fontTheme = fontTheme
        self.colorTheme = colorTheme
        self.localized = localized
        self.logoURL = logoURL
    }
}
