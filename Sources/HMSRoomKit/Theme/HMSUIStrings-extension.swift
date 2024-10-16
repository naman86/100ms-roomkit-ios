//
//  HMSUIStrings-extension.swift
//  HMSRoomKit
//
//  Created by Naman Singhal on 16/10/24.
//

import SwiftUI
import Combine
import HMSSDK

extension HMSUIStrings {
    
    func string(_ key: HMSStrings) -> String {
        switch key {
        case .leaveSession:
            return leaveSession
        case .leaveSessionMessage:
            return leaveSessionMessage
        }
    }
}

public enum HMSStrings {
    case leaveSession
    case leaveSessionMessage
}
