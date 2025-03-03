//
//  Profile.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import APIManager

public struct ProfileContainer: Decodable, APIReturnable {
    public let profiles: [Profile]

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(ProfileContainer.self, from: data)
    }
}

public struct Profile: Codable, APIReturnable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case points
        case foodWave
        case discord
        case avatarUrl
    }

    public let id: String
    public let firstName: String
    public let lastName: String
    public let points: Int
    public let foodWave: Int
    public let discord: String
    public let avatarUrl: String
}

public struct ProfileFavorites: Codable, APIReturnable {
    public let id: String
    public let profiles: Set<String>
}

public struct LeaderboardProfileContainer: Decodable, APIReturnable {
    public let profiles: [LeaderboardProfile]

    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self = try decoder.decode(LeaderboardProfileContainer.self, from: data)
    }
}

public struct LeaderboardProfile: Codable, APIReturnable {
    internal enum CodingKeys: String, CodingKey {
        case id
        case discord
        case points
    }

    public let id: String
    public let discord: String
    public let points: Int
}

public struct TiersContainer: Decodable, APIReturnable {
    public let tiers: [Tier]
    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        let tiers = try decoder.decode([Tier].self, from: data)
        self.tiers = tiers
    }
}

public struct Tier: Codable, APIReturnable {
    public let name: String
    public let threshold: Int
}
