//
//  HMSUIStrings.swift
//  HMSRoomKit
//
//  Created by Naman Singhal on 16/10/24.
//

import SwiftUI
import Combine
import HMSSDK

public class HMSUIStrings: ObservableObject {
    
    public init() {}
    
    @Published public var leaveSession: String = "Leave Session"
    @Published public var leaveSessionMessage: String = "Others will continue after you leave. You can join the session again."
    
}
