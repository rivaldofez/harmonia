//
//  SongResponse.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation

struct SongResponse: Codable {
    let resultCount: Int?
    let results: [SongItemResponse]?
}

struct SongItemResponse: Codable, Hashable {
    let wrapperType: String?
    let artistID, collectionID: Int?
    let collectionName, artistName: String?
    let collectionCensoredName: String?
    let artistViewURL, collectionViewURL: String?
    let artworkUrl60, artworkUrl100: String?
    let collectionPrice: Double?
    let collectionExplicitness: String?
    let trackCount: Int?
    let copyright: String?
    let country: String?
    let currency: String?
    let releaseDate: String?
    let primaryGenreName: String?
    let previewURL: String?
    let description: String?
    let kind: String?
    let trackID: Int?
    let trackName: String?
    let trackCensoredName: String?
    let collectionArtistID: Int?
    let collectionArtistViewURL, trackViewURL: String?
    let artworkUrl30: String?
    let trackPrice, trackRentalPrice, collectionHDPrice, trackHDPrice: Double?
    let trackHDRentalPrice: Double?
    let trackExplicitness: String?
    let discCount, discNumber, trackNumber, trackTimeMillis: Int?
    let contentAdvisoryRating, shortDescription, longDescription: String?
    let hasITunesExtras, isStreamable: Bool?

    enum CodingKeys: String, CodingKey {
        case wrapperType
        case artistID = "artistId"
        case collectionID = "collectionId"
        case artistName, collectionName, collectionCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case collectionPrice
        case artworkUrl60, artworkUrl100, collectionExplicitness, trackCount, copyright, country, currency, releaseDate, primaryGenreName
        case previewURL = "previewUrl"
        case description, kind
        case trackID = "trackId"
        case trackName, trackCensoredName
        case collectionArtistID = "collectionArtistId"
        case collectionArtistViewURL = "collectionArtistViewUrl"
        case trackViewURL = "trackViewUrl"
        case artworkUrl30
        case trackPrice, trackRentalPrice
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case trackHDRentalPrice = "trackHdRentalPrice"
        case trackExplicitness, discCount, discNumber, trackNumber, trackTimeMillis, contentAdvisoryRating, shortDescription, longDescription, hasITunesExtras, isStreamable
    }
}
