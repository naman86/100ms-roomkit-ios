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
    
    @Published public var you: String = "You"
    @Published public var someone: String = "Someone"
    @Published public var live: String = "LIVE"
    @Published public var youLeftSession: String = "You left the session"
    @Published public var leftByMistake: String = "Left by mistake?"
    @Published public var rejoin: String = "Rejoin"
    
    @Published public var stop: String = "Stop"
    @Published public var retry: String = "Retry"
    @Published public var view: String = "View"
    @Published public var vote: String = "Vote"
    @Published public var answer: String = "Answer"
    
    @Published public var feedbackThakYou: String = "Thank you for your feedback!"
    @Published public var feedbackMessage: String = "Your answers help us improve."
    
    @Published public var enablePermissions: String = "Enable Permissions"
    @Published public var enablePermissionsMessage: String = "Sharing your camera and microphone permissions helps us give you the optimal experience"
    
    @Published public var leave: String = "Leave"
    @Published public var leaveSession: String = "Leave Session"
    @Published public var leaveSessionMessage: String = "Others will continue after you leave. You can join the session again."
    
    @Published public var endSession: String = "End Session"
    @Published public var endSessionMessageStreamPresented: String = "The session and stream will end for everyone. You can’t undo this action."
    @Published public var endSessionMessageStreamNotPresented: String = "The session will end for everyone. You can’t undo this action."
    
    @Published public var volume: String = "Volume"
    @Published public var cancel: String = "Cancel"
    
    @Published public var streamEnded: String = "Stream ended"
    @Published public var streamYetToStart: String = "Stream yet to start"
    
    @Published public var welcome: String = "Welcome!"
    @Published public var description: String = "Description"
    @Published public var sessionEndedMessage: String = "Have a nice day!"
    @Published public var sesionYetToStartMessage: String = "Sit back and relax"
    
    @Published public var speakerSettings: String = "Speaker Settings"
    @Published public var speaker: String = "Speaker"
    @Published public var phone: String = "Phone"
    @Published public var otherDevices: String = "Other devices"
    
    @Published public var name: String = "Name"
    @Published public var changeName: String = "Change Name"
    @Published public var enterName: String = "Enter Name..."
    @Published public var change: String = "Change"
    
    @Published public var errorTitle: String = "Error"
    
    @Published public var joinNow: String = "Join Now"
    @Published public var decline: String = "Decline"
    @Published public var switchRole: String = "Switch Role"
    @Published public var removeParticipant: String = "Remove Participant"
    
    @Published public var joinStageMessage: String = "You’re invited to join the stage"
    @Published public var setupAudioVideoMessage: String = "Setup your audio and video before joining"
    
    @Published public var minimizeYourTile: String = "Minimize Your Tile"
    @Published public var unpinTile: String = "Unpin tile for myself"
    @Published public var pinTile: String = "Pin tile for myself"
    @Published public var spotlightTileRemove: String = "Remove from spotlight for Everyone"
    @Published public var spotlightTileAdd: String = "Spotlight Tile for Everyone"
    
    @Published public var startingLiveStream: String = "Starting live stream..."
    @Published public var raisedHand: String = "raised hand"
    
    @Published public var screen: String = "Screen"
    @Published public var youAreSharingScreen: String = "You are sharing your screen"
    @Published public var stopScreenshare: String = "Stop Screenshare"
    
    @Published public var declineToJoinStage: String = "declined the request to join the stage"
    @Published public var lostInternetConnectReconnecting: String = "You have lost your network connection. Trying to reconnect."
    @Published public var recordingFailedToStart: String = "Recording failed to start"
    
    @Published public var poorConnection: String = "Poor connection"
    @Published public var videoResumeWhenConnectionImproves: String = "The video will resume automatically when the connection improves"
}
