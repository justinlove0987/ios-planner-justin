//
//  Structs.swift
//  Planner
//
//  Created by 曾柏瑒 on 2022/1/4.
//

import Foundation


struct AddChallenge {
    let name: String
    let date: Date
    let totalAmount: Int
    let currentProgress: Int
    let invitedFriendInformations: [InvitedFriendInformation]
}

struct InvitedFriendInformation {
    let email: String
    let name: String
    var isInvited: Bool
}

struct MyChallenge {
    let id: String
    let name: String
    let date: Date
    var currentProgress: Int
    let totalAmount: Int
}

struct Challenge {
    let id: String
    let name: String
    let date: Date
    let member_informations: [MemberInformation]
}

struct MemberInformation {
    let email: String
    let name: String
    let totalAmount: Int
    var currentProgress: Int
    var isJoined: Bool
}

struct MyChallengeData {
    let totalAmount: Int
    var current_progress: Int
}

struct ChatAppUser {
    let username: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictrueFileName: String {
        // justinlove0987-gmail-com_profile_picture.png/
        return "\(safeEmail)_profile_picture.png"
    }
}
