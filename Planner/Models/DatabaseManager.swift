//
//  DatabaseManager.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/16.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}


extension DatabaseManager {
    public enum DatabaseError: Error {
        case failedToFetch
        case failedToConvert
    }
    
    public func changeUsername(newUserName: String) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        self.database.child("\(currentUserSafeEmail)/username").setValue(newUserName)
        
        self.database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard var users = snapshot.value as? [[String: String]] else {
                return
            }
            
            for (i, user) in users.enumerated() {
                if currentUserSafeEmail == user["email"] {
                    users[i]["name"] = newUserName
                }
            }
            
            self.database.child("users").setValue(users)
        }
        
        self.database.child("\(currentUserSafeEmail)/challenges").observeSingleEvent(of: .value) { snapshot in
            guard let challenges = snapshot.value as? [[String: Any]] else {
                return
            }
            
            for challenge in challenges {
                if let challengeId = challenge["id"] as? String {
                    self.database.child("challenges/challengeId_\(challengeId)/member_informations").observeSingleEvent(of: .value) { snapshot in
                        guard var memberInformations = snapshot.value as? [[String: Any]] else {
                            return
                        }
                        
                        for (i,memberInformation) in memberInformations.enumerated() {
                            if let _ = memberInformation["name"] as? String,
                               currentUserSafeEmail == memberInformation["email"] as? String {
                                memberInformations[i]["name"] = newUserName
                            }
                        }
                        
                        self.database.child("challenges/challengeId_\(challengeId)/member_informations").setValue(memberInformations)
                        
                    }
                }
                
            }
            
            
        }

    }
    
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        self.database.child("\(path)").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public func setUserDefaults(with email: String) {
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getDataFor(path: safeEmail) { result in
            switch result {
            case .success(let data):
                guard let userData = data as? [String: Any],
                      let username = userData["username"] as? String else {
                          return
                      }
                
                UserDefaults.standard.set(username, forKey: "name")
                UserDefaults.standard.set(email, forKey: "email")
                
            case .failure(let error):
                print("failed to read data with error \(error)")
            }
        }
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
}

// Users
extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
                return
            }
            
        }
    }
    
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "username": user.username ]) { error , _ in
                guard error == nil else {
                    print("filed to wirte to database")
                    completion(false)
                    return
                }
                
                self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                    
                    var users: [[String: String]]
                    
                    if var appendUserCollection = snapshot.value as? [[String: String]] {
                        //append to user dictionary
                        let newElement = [
                            "name": user.username,
                            "email": user.safeEmail
                        ]
                        
                        appendUserCollection.append(newElement)
                        users = appendUserCollection
                        
                    } else {
                        // create the array
                        let createUserCollection: [[String: String]] = [
                            [
                                "name": user.username,
                                "email": user.safeEmail
                            ]
                        ]
                        
                        users = createUserCollection
                    }
                    
                    self.database.child("users").setValue(users) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                }
            }
    }
    
}

// Friends
extension DatabaseManager {
    public func addFriend(currentUserEmail: String, targetUserEmail: String, targetUserName: String) {
        database.child(currentUserEmail).observeSingleEvent(of: .value) { snapshot in
            self.database.child("\(currentUserEmail)/friends").observeSingleEvent(of: .value) { snapshot in
                
                let targetInformation = ["email": targetUserEmail, "name": targetUserName]
                
                if var friendInformations = snapshot.value as? [[String: String]] {
                    friendInformations.append(targetInformation)
                    self.database.child("\(currentUserEmail)/friends").setValue(friendInformations)
                    
                } else {
                    self.database.child("\(currentUserEmail)/friends").setValue([targetInformation])
                }
            }
            
        }
    }
    
    public func deleteFriend(with removeEmail: String) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: email)
        self.database.child("\(currentUserSafeEmail)/friends").observeSingleEvent(of: .value) { snapshot in
            guard var friends = snapshot.value as? [[String: String]] else { return }
            
            for (i, friend) in friends.enumerated() {
                if let friendEmail = friend["email"],
                   removeEmail == friendEmail {
                    friends.remove(at: i)
                }
            }
            self.database.child("\(currentUserSafeEmail)/friends").setValue(friends)
            
        }
    }
    
    public func getFriends(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        database.child("\(currentUserSafeEmail)/friends").observeSingleEvent(of: .value) { snapshot in
            
            guard let friendInformations = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            
            completion(.success(friendInformations))
        }
    }
    
}

// challenges
extension DatabaseManager {
    func addChallenge(with challengeId: String, challenge: AddChallenge) {
        // user emails
        guard let safeEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentUserName = UserDefaults.standard.value(forKey: "name") as? String else {
                  return
              }
        
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: safeEmail)
        var invitedMemberEmails = [currentUserSafeEmail]
        
        // add my information
        
        var memberInformations = [[String: Any]]()
        
        let myInformation = ["email": currentUserSafeEmail,
                             "name": currentUserName,
                             "total_amount": challenge.totalAmount,
                             "current_progress": challenge.currentProgress,
                             "is_joined": true] as [String : Any]
        
        memberInformations.append(myInformation)
        
        
        // add other member information
        for invitedFriendInformation in challenge.invitedFriendInformations {
            let otherUserSafeEmail = DatabaseManager.safeEmail(emailAddress: invitedFriendInformation.email)
            invitedMemberEmails.append(otherUserSafeEmail)
            
            let otherMemberInformation = ["email": otherUserSafeEmail,
                                          "name": invitedFriendInformation.name,
                                          "total_amount": challenge.totalAmount,
                                          "current_progress": challenge.currentProgress,
                                          "is_joined": false] as [String : Any]
            memberInformations.append(otherMemberInformation)
            
        }
        
        database.child("challenges/challengeId_\(challengeId)/member_informations").setValue(memberInformations)
        
        // store challengeId for users
        let dateString = HomeVC.dateFormatter.string(from: challenge.date)
        
        for safeEmail in invitedMemberEmails {
            database.child("\(safeEmail)/challenges").observeSingleEvent(of: .value) { snapshot in
                let newChallenge = [
                    "id": challengeId,
                    "name": challenge.name,
                    "date": dateString,
                    "current_progress": challenge.currentProgress,
                    "total_amount": challenge.totalAmount] as [String : Any]
                
                if var challenges = snapshot.value as? [[String: Any]] {
                    challenges.append(newChallenge)
                    
                    self.database.child("\(safeEmail)/challenges").setValue(challenges)
                } else {
                    self.database.child("\(safeEmail)/challenges").setValue([newChallenge])
                }
            }
        }
        
    }
    
    func deleteChallenge(with challengeId: String) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        // remove value from self email
        database.child("\(safeEmail)/challenges").observeSingleEvent(of: .value) { snapshot in
            
            guard var challenges = snapshot.value as? [[String: Any]] else {
                return
            }
            
            for (i, challenge) in challenges.enumerated() {
                if let id = challenge["id"] as? String,
                   challengeId == id {
                    challenges.remove(at: i)
                }
            }
            
            self.database.child("\(safeEmail)/challenges").setValue(challenges)
        }
        
        // remove value from challenge id
        database.child("challenges/challengeId_\(challengeId)/member_informations").observeSingleEvent(of: .value) { snapshot in
            guard var memberInformations = snapshot.value as? [[String: Any]] else {
                return
            }
            
            for (i, memberInformation) in memberInformations.enumerated() {
                if let memberEmail = memberInformation["email"] as? String,
                   safeEmail == memberEmail {
                    memberInformations.remove(at: i)
                }
            }
            
            self.database.child("challenges/challengeId_\(challengeId)/member_informations").setValue(memberInformations)
            
        }
        
    }
    
    func getCurrentUserChallengeInformations(completion: @escaping (Result<[MyChallenge], Error>) -> Void) {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(.failure(DatabaseError.failedToFetch))
            return
        }
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        
        database.child("\(currentUserSafeEmail)/challenges").observe(.value) { snapshot in
            guard let currentUserChallengeInformation = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            
            
            let userChallengeInformations: [MyChallenge] = currentUserChallengeInformation.compactMap { dictonary in
                guard let id = dictonary["id"] as? String,
                      let name = dictonary["name"] as? String,
                      let dateString = dictonary["date"] as? String,
                      let currentPorgress = dictonary["current_progress"] as? Int,
                      let totalAmount = dictonary["total_amount"] as? Int,
                      let date = HomeVC.dateFormatter.date(from: dateString) else {
                          return nil
                      }
                
                return MyChallenge(id: id, name: name, date: date, currentProgress: currentPorgress, totalAmount: totalAmount)
            }
            
            
            completion(.success(userChallengeInformations))
        }
        
    }
    
    func getMemberInformation(with challengeId: String, completion: @escaping (Result<[MemberInformation], Error>) -> Void) {
        
        database.child("challenges/challengeId_\(challengeId)/member_informations").observe(.value) { snapshot in
            guard let memberInformations = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let decodedMberInformations: [MemberInformation] = memberInformations.compactMap { dictonary in
                guard let email = dictonary["email"] as? String,
                      let name = dictonary["name"] as? String,
                      let totalAmount = dictonary["total_amount"] as? Int,
                      let currentProgress = dictonary["current_progress"] as? Int,
                      let isJoined = dictonary["is_joined"] as? Bool else {
                          completion(.failure(DatabaseError.failedToConvert))
                          return nil
                      }
                
                return MemberInformation(email: email,
                                         name: name,
                                         totalAmount: totalAmount,
                                         currentProgress: currentProgress,
                                         isJoined: isJoined)
            }
            
            completion(.success(decodedMberInformations))
        }
    }
    
    func calculateProgress(with id: String, sign: String) {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        database.child("challenges/challengeId_\(id)/member_informations").observeSingleEvent(of: .value) { snapshot in
            guard var memberInformations = snapshot.value as? [[String: Any]] else {
                return
            }
            
            
            
            for (i, memberInformation) in memberInformations.enumerated() {
                if let memberEmail =  memberInformation["email"] as? String,
                   let name = memberInformation["name"] as? String,
                   let totalAmount = memberInformation["total_amount"] as? Int,
                   var currentProgress = memberInformation["current_progress"] as? Int,
                   let isJoined = memberInformation["is_joined"] as? Bool,
                   currentUserSafeEmail == memberEmail {
                    
                    switch sign {
                    case "+":
                        currentProgress += 1
                    case "-":
                        currentProgress -= 1
                    case "=":
                        currentProgress = totalAmount
                    default:
                        break
                    }
                    
                    
                    let updateMember = ["email": memberEmail,
                                        "name": name,
                                        "total_amount": totalAmount,
                                        "current_progress": currentProgress,
                                        "is_joined": isJoined
                    ] as [String : Any]
                    
                    memberInformations[i] = updateMember
                }
            }
            self.database.child("challenges/challengeId_\(id)/member_informations").setValue(memberInformations)
            
        }
        
        database.child("\(currentUserSafeEmail)/challenges").observeSingleEvent(of: .value) { snapshot in
            guard var myChallenges = snapshot.value as? [[String: Any]] else {
                return
            }
            
            for (i, challenge) in myChallenges.enumerated() {
                if var currentProgress = challenge["current_progress"] as? Int,
                   let totalAmount = challenge["total_amount"] as? Int,
                   let date = challenge["date"] as? String,
                   let myId = challenge["id"] as? String,
                   let name = challenge["name"] as? String,
                   myId == id {
                    
                    switch sign {
                    case "+":
                        currentProgress += 1
                    case "-":
                        currentProgress -= 1
                    case "=":
                        currentProgress = totalAmount
                    default:
                        break
                    }
                    
                    let updateMyChallenge = ["id": myId,
                                             "name": name,
                                             "total_amount": totalAmount,
                                             "current_progress": currentProgress,
                                             "date": date
                    ] as [String : Any]
                    
                    myChallenges[i] = updateMyChallenge
                }
                
                
            }
            print(myChallenges)
            self.database.child("\(currentUserSafeEmail)/challenges").setValue(myChallenges)
        }
        
        
    }
    
    
    func addCurrentProgress(with id: String) {
        calculateProgress(with: id, sign: "+")
    }
    
    func subtractCurrentProgress(with id: String) {
        calculateProgress(with: id, sign: "-")
    }
    
    func completeCurrentProgress(with id: String) {
        calculateProgress(with: id, sign: "=")
    }
}
